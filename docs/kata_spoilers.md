
# 1) Setup a pipeline

## Create a scale set
* Do this via the portal
* Use an ubuntu image
* Standard_B2s

## Create an agent pool
* Create the agent pool
    * 30 minutes idle, max 2 vm's, have 0 on standby
* Attach it to the vmss

## Create a pipeline
* Create the yaml, in a repo
* Create the pipeline, attached to that
* Have the pipeline echo "Hello world"
* Make sure not to clone the repo either

* Hello world
```yml
pool:
  name: Agents

stages:
- stage: Build
  jobs:
  - job: BuildJob
    steps:
    - checkout : none
    - task: Bash@3
      inputs:
        targetType: 'inline'
        script: |
          echo 'Hello world'
```

# Tear it down ( Optional )
* Delete the pipeline
* Delete the agent pool
* Delete the vmss
* Do this all at an agent level


---


# 2) Stages and top level overviews:

## Hello world:
* Create a pipeline
* Have:
    * A stage
    * A job
    * A task
    * Echoing hello world

## Setup stages:

* Create two stages
    * that has a pair of jobs
        * both have a pair of tasks
        * Echo a unique value ( the name of the stage + the job name + a hard coded value )
            * e.g. echo "first - echo_one - 2"
        * hardcode everything, don't use templating 
        * add one final task to skip checkout

* In That's a total of:
    * 2 stages
    * 4 jobs
    * 8 tasks

* Make the second stage run AFTER the first stage

## Parallel jobs / parallel stages
* Make stage one and stage two, run in parallel
* Create a third stage, that only runs when the other 2 have stopped
* The jobs HOWEVER must run in serial, within their stage

* To recap:
    * Stage A and Stage B should run in parallel
    * Jobs A and Jobs B, within stage A, should run one AFTER the other
    * Stage C should run only once Stage A and Stage B have completed

```yml
pool:
  name : linux

stages:
- stage: first
  jobs:
  - job: echo_one
    steps:
    - checkout : none
    - task : Bash@3
      inputs : 
        targetType : "inline"
        script : |
            echo "first - echo_one - 1"

    - task : Bash@3
      inputs : 
        targetType : "inline"
        script : |
            echo "first - echo_one - 2"

  - job: echo_two
    dependsOn : echo_one
    steps:
    - checkout : none
    - task : Bash@3
      inputs : 
        targetType : "inline"
        script : |
            echo "first - echo_two - 1"

    - task : Bash@3
      inputs : 
        targetType : "inline"
        script : |
            echo "first - echo_two - 2"

- stage: second
  dependsOn : []
  jobs:
  - job: echo_one
    steps:
    - checkout : none
    - task : Bash@3
      inputs : 
        targetType : "inline"
        script : |
            echo "second - echo_one - 1"

    - task : Bash@3
      inputs : 
        targetType : "inline"
        script : |
            echo "second - echo_one - 2"

  - job: echo_two
    dependsOn : echo_one
    steps:
    - checkout : none
    - task : Bash@3
      inputs : 
        targetType : "inline"
        script : |
            echo "second - echo_two - 1"

    - task : Bash@3
      inputs : 
        targetType : "inline"
        script : |
            echo "second - echo_two - 2"

- stage : third
  dependsOn : 
    - first
    - second
  jobs:
    - job : final
      steps:
      - task : Bash@3
        inputs : 
          targetType : "inline"
          script : |
            echo "final"
```

---

# 3) Ifs, fn's, each and general syntax:

## Each
* Create a parameter:
    * make it an array 
    * call it "siteCodes"
    * give it the default value of : zz01, zz04, je03
       
* Use that with each, to generate 3 stages

```yml
pool:
  name : linux

parameters:
- name: 'siteCodes'
  type: object
  default: ['zz01', 'zz04', 'je03']

stages:
- ${{ each siteCode in parameters.siteCodes }}:
  - stage: Sandbox_${{siteCode}}
    displayName: Echo a the site code ${{ siteCode }}
    jobs:
    - job:
      steps :
      - task : Bash@3
        inputs :
          targetType : "inline"
          script : |
            echo "Sitecode : ${{ siteCode }}"
```


## Conditional stage insertion:

* Use conditional insertion to
    * Insert an extra stage, if there's 3 parameters
    * This just echos "BONUS STAGE GET"
    * Make it depend on ALL the previous stages

```yml
- ${{ if eq(length(parameters.siteCodes), 3) }}:
  - stage: bonus
    dependsOn: 
    - ${{ each siteCode in parameters.siteCodes }}:
      - ${{ siteCode }}
    - sitecode_${{ parameters.siteCode }}

    jobs:
    - job: echo
      steps:
      - checkout: none
      - task: Bash@3
        inputs:
          targetType: "inline"
          script: |
            echo "Bonus Get"
```



* Run the pipeline with:
    * sa01, zz09, je03         -> Should have 4 stages ( including the bonus )
    * The default 3 site codes -> Should skip one stage ( zz04 ) and create a 4th stage, the bonus stage will skip
    * sa01, zz04, zz09, je03   -> Should have 4 stages, zz04 is skipped, it doesn't have the bonus stage

## Conditions
* Give the stage block a condition
* Skip a stage, if it's value is zz04

* Run the pipeline with the defaults ( 3, including zz04 )
    * Note that zz04 skips
    * Note that bonus is skipped

condition : not(eq('${{siteCode}}','zz04'))

## Job status check functions
* Run the pipeline with the defaults ( including zz04 )
* Make the bonus stage RUN even if something fails, by adding a condition
* As of right now, if something is skipped, it is skipped

* condition : always()

## Templating

* Create a pair of templates:
    * One for the siteCodes stage, 
        * make it take one argument
        * it's the siteCode ( singular )

        * Leave the each in the main template

    * One for bonus stage
        * Leave the conditional in the main template

* When ran, these templates should result in the same thing as before

```yml
# Main pipeline yml
pool:
  name: linux

parameters:
- name: siteCodes
  type: object 
  default: 
  - zz01
  - zz04
  - je03

stages:
- ${{ each siteCode in parameters.siteCodes }}:
  - template: stages.yml 
    parameters:
      siteCode : "${{siteCode}}"

- ${{ if eq(length(parameters.siteCodes), 3) }}: 
  - template : bonus.yml
```

```yml
# Stages.yml
parameters:
  - name: siteCode
    type: string

stages:
- stage: Sandbox_${{ parameters.siteCode}}
  condition : not(eq('${{ parameters.siteCode}}','zz04'))
  jobs: 
  - job: echo
    steps:
    - checkout: none
    - task: Bash@3
      inputs: 
        targetType: "inline"
        script: |
          echo "Site Code : ${{ parameters.siteCode }}"
```

```yml
# Bonus yml
stages:
- stage: bonus
  condition : always()
  jobs: 
  - job: echo
    steps:
    - checkout: none
    - task: Bash@3
      inputs: 
        targetType: "inline"
        script: |
          echo "BONUS GET"
```

---


# 4) Variables + templates

* passing them out of tasks
* passing them out of jobs
* passing them out of stages
* passing them out of templates

# Setting up:
* Have a stage that echos
* Create a variable, called holder, with a string value, with a default of "Initial Value"

* Create:
    * A stage
        * A job
            * A task that echos the variables compile time value

                  echo "${{ variables.holder }}"

            * A task that sets the variables value to "Updated Value"
                  echo "##vso[task.setvariable variable=holder;]testvalue"

            * A task that echos the variables compile time value, and run time value

                  echo "${{ variables.holder }}"
                  echo "$( holder )"

        * A job:
            * A task that echos the variables run time value
                  echo "${{ variables.holder }}"

    * A stage:
        * A task that echos the run time value
              echo "${{ variables.holder }}"

* Tests:
    * When ran, the pipeline stages should show:
        * Stage A - Job 1 - task 1:
            * Initial Value
            * Initial Value

        * Stage A - Job 1 - task 3:
            * Initial Value
            * Updated Value

        * Stage A - Job 2 - task 1:
            * Initial Value

        * Stage B - Job 1 - task 1:
            * Initial Value

```yml
pool:
  name: linux

variables:
- name: holder
  value: Initial Value

stages:
- stage:
  jobs: 
  - job: joba
    steps:
    - checkout: none
    - task: Bash@3
      inputs:
        targetType: "inline"
        script: |
          echo "${{ variables.holder }}"

    - task: Bash@3
      inputs:
        targetType: "inline"
        script: |
          echo "##vso[task.setvariable variable=holder;]testvalue"

    - task: Bash@3
      inputs:
        targetType: "inline"
        script: |
          echo "${{ variables.holder }}"
          echo $(holder)

  - job:
    dependsOn: joba
    steps:
    - checkout: none
    - task: Bash@3
      inputs:
        targetType: "inline"
        script: |
          echo "${{ variables.holder }}"
          echo "$( holder )"

- stage:
  jobs: 
  - job:
    steps:
    - checkout: none
    - task: Bash@3
      inputs:
        targetType: "inline"
        script: |
          echo "${{ variables.holder }}"
          echo "$( holder )"
```


# Variable changes are scoped to a job level, not passed between jobs, unless you use outputs
* Setup the out variable, to pass it from Stage 1, job 1, to stage 1, job 2
    echo "##vso[task.setvariable variable=holder;isOutput=true]Updated Value"

* Update the echo task, to also keep it echoing the updated value
    * stage 1, job 1, task 3 -> Keep it echoing:
        * Initial Value
        * Updated Value

```yml
- task: Bash@3
  inputs:
    targetType: "inline"
    script: |
      echo "${{ variables.holder }}"
      echo $(fatbutt.holder)
```

* Update stage 1, job 2, task 1 -> Have it echo the stuff
```yml
- job: check
dependsOn: run
variables:
  myTest: $[ dependencies.run.outputs['fatbutt.myOutputVar'] ]
steps:
- checkout: none
- task: Bash@3
  inputs:
    targetType: "inline"
    script: |
      echo "${{ variables.holder }}"
      echo $(myTest)
```

```yml
# Completed:
stages:
- stage:
  jobs: 
  - job: run
    steps:
    - checkout: none
    - task: Bash@3
      inputs:
        targetType: "inline"
        script: |
          echo "${{ variables.holder }}"

    - task: Bash@3
      name : fatbutt
      inputs:
        targetType: "inline"
        script: |
          echo "##vso[task.setvariable variable=myOutputVar;isOutput=true]Updated Value"

    - task: Bash@3
      inputs:
        targetType: "inline"
        script: |
          echo "${{ variables.holder }}"
          echo $(fatbutt.myOutputVar)

  - job: check
    dependsOn: run
    variables:
      myTest: $[ dependencies.run.outputs['fatbutt.myOutputVar'] ]
    steps:
    - checkout: none
    - task: Bash@3
      inputs:
        targetType: "inline"
        script: |
          echo "${{ variables.holder }}"
          echo $(myTest)
```

# Passing OUT variables, on a stage level
* name both stages
* make stage 2, depend on stage 1
* Declare a stage variable, called from first
* Grab the output variable from the first

```yml
- stage: second
  dependsOn: first
  variables:
    fromFirst : $[ stageDependencies.first.run.outputs['fatbutt.myOutputVar'] ]
  jobs: 
  - job:
    steps:
    - checkout: none
    - task: Bash@3
      inputs:
        targetType: "inline"
        script: |
          echo "${{ variables.holder }}"
          echo "$(fromFirst)"
```

```yml
# Completed example

pool:
  name: linux

variables:
- name: holder
  value: Initial Value

stages:
- stage: first
  jobs: 
  - job: run
    steps:
    - checkout: none
    - task: Bash@3
      inputs:
        targetType: "inline"
        script: |
          echo "${{ variables.holder }}"

    - task: Bash@3
      name : fatbutt
      inputs:
        targetType: "inline"
        script: |
          echo "##vso[task.setvariable variable=myOutputVar;isOutput=true]Updated Value"

    - task: Bash@3
      inputs:
        targetType: "inline"
        script: |
          echo "${{ variables.holder }}"
          echo $(fatbutt.myOutputVar)

  - job: check
    dependsOn: run
    variables:
      myTest: $[ dependencies.run.outputs['fatbutt.myOutputVar'] ]
    steps:
    - checkout: none
    - task: Bash@3
      inputs:
        targetType: "inline"
        script: |
          echo "${{ variables.holder }}"
          echo $(myTest)

- stage: second
  dependsOn: first
  variables:
    fromFirst : $[ stageDependencies.first.run.outputs['fatbutt.myOutputVar'] ]
  jobs: 
  - job:
    steps:
    - checkout: none
    - task: Bash@3
      inputs:
        targetType: "inline"
        script: |
          echo "${{ variables.holder }}"
          echo "$(fromFirst)"


```

# Passing OUT variables, from templates?
* Isolate the first stage into a template file
* Nothing should change, it should still continue to work fine
