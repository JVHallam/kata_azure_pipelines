
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

---


# 3) Ifs, fn's, each and general syntax:

