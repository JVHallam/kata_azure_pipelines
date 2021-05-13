
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
* Stages
* Jobs
* Steps
* tasks
* Parallel jobs / parallel stages
* Depends on 

# 3) Ifs, fn's and general syntax:
* conditionals
* if
* eq
* conditional flows

# 4) Variables + templates
* Templates
* variables
* parameters
* passing variables between :
    * Steps
    * Jobs
    * Stages

* Passing variables from one stage, into a template for the next stage
