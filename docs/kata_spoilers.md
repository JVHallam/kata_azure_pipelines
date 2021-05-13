
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
    * Teardown the 

# 2) Stages and top level overviews:

## Setup stages:


* Create two stages
    * that has a pair of jobs
        * both have a pair of tasks
        * Echo a unique value ( the value 1 through 100 or something )

* Make each stage, depend on the previous one

# Parallel jobs / parallel stages
* Make each stage run in parallel
* Create a third stage, that only runs when the other 2 have stopped
* 

# Variables
* Create 8 variables

* each job has it's own variable
    * Templating variables
        * echo "${ this shit }"

# Each
* Use an array instead of 8 single variables

* Use an array for job ( that's 4 single arrays, 2 stages, 2 jobs per stage => 4 arrays, with 2 values )

* Use the each keyword, to generate run 2 tasks, using 1 task block
* Do the same for the jobs
* Do the same for the stages

* Until you have:
* 1 stage, 1 job, 1 tasks
* Followed by 1 more stage, that only runs when the above has finished


# 3) Ifs, fn's and general syntax:
* conditionals
* if
* eq
* conditional flows
* Filtered arrays

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
