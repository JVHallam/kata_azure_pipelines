
# 1) Setup a pipeline

* Create a scale set
    * Do this via the portal, the terraform is a nightmare

* Create an agent pool, attaching it to the VMSS

* Create a pipeline

* Hello world
pool:
  name: Agents

stages:
- stage: Build
  jobs:
  - job: BuildJob
    steps:
    - task: Bash@3
      inputs:
        targetType: 'inline'
        script: |
          echo 'Hello world'

* Teardown
    * Delete the pipeline
    * Delete the agent pool
    * Do this all at the organization level. Right at the top

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
        * Echo a unique value ( the value 1 through 100 or something )

* That's a total of:
    * 2 stages
    * 4 jobs
    * 8 tasks

* Make the second stage run AFTER the first stage

## Parallel jobs / parallel stages
* Make each stage run in parallel
* Create a third stage, that only runs when the other 2 have stopped
* The jobs HOWEVER must run in serial, within their stage

* To recap:
    * Stage A and Stage B should run in parallel
    * Jobs A and Jobs B, within stage A, should run one AFTER the other
    * Stage C should run only once Stage A and Stage B have completed

# Variables
* Create 8 variables
* each job has it's own variable
    * Templating variables
        * echo "${ this shit }"


## The final product

```yml
pool:
  name : linux

stages:
- stage: first
  dependsOn : []
  jobs:
  - job : 
    steps :
    - task : Bash@3
      inputs :
        targetType : "inline"
        script : |
          echo "Hello World"
    - task : Bash@3
      inputs :
        targetType : "inline"
        script : |
          echo "Hello World"

  - job : 
    steps :
    - task : Bash@3
      inputs :
        targetType : "inline"
        script : |
          echo "Hello World"
    - task : Bash@3
      inputs :
        targetType : "inline"
        script : |
          echo "Hello World"
      
- stage: second
  dependsOn : []
  jobs:
  - job : 
    steps :
    - task : Bash@3
      inputs :
        targetType : "inline"
        script : |
          echo "Hello World"
    - task : Bash@3
      inputs :
        targetType : "inline"
        script : |
          echo "Hello World"

  - job : 
    steps :
    - task : Bash@3
      inputs :
        targetType : "inline"
        script : |
          echo "Hello World"
    - task : Bash@3
      inputs :
        targetType : "inline"
        script : |
          echo "Hello World"

- stage : final
  dependsOn : 
  - first
  - second
  jobs:
  - job : 
    steps :
    - task : Bash@3
      inputs:
        targetType : "inline"
        script : |
          echo "Finished!"
```

---

# 3) Ifs, fn's and general syntax:
* conditionals
* if
* eq
* conditional flows
* Filtered arrays

# Each 
* Use 2d arrays, instead of 8 seperate variables
    stage [ job [ task, task ], job [ task, task ] ]
    stage [ job [ task, task ], job [ task, task ] ]

* Use each to auto generate 2 stages
* Use each to auto generate the 2 jobs
* Use each to auto generate 2 tasks

* Use the array indexes, to get access to the values

* Until you have:
* 1 stage, 1 job, 1 tasks
* That generates:
    * 2 Stages, 4 jobs, 8 tasks

* Followed by 1 more stage, that only runs when the above has finished

# This will generate the fucking stuff i need! YEAH BOI!

pool:
  name : linux

parameters:
- name: 'siteCodes'
  type: object
  default: ['sa01', 'zz04', 'zz09']

stages:
- stage: Sandbox
  displayName: Sandbox SQL database deployments
  jobs:
  - ${{ each siteCode in parameters.siteCodes }}:
    - job:
      steps :
      - task : Bash@3
        inputs :
          targetType : "inline"
          script : |
            echo "Hello World"


# 4) Variables + templates
* Templates
* parameters

* passing variables around:
    * output variables
        * https://www.nigelfrank.com/blog/azure-devops-output-variables/
    * passing variables between :
        * Steps
        * Jobs
        * Stages

* Passing variables from one stage, into a template for the next stage

* Environment variables

* Extra commands:
    * artifacts
    * logging commands
