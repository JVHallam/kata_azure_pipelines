
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
    * Do this all at an organisations level

* Delete any branches:
    * git push --delete branch-name-thing


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

## Parameter:
* Create a parameter
    * call it "siteCode"
    * set the default value to "zz01"
    * Set it to be a string

* Create a stage
    * Create a job
        * Create a task that echos the value of that parameter

* TEST:
    * Automated Run:
        * The automated pipeline has a task that echos zz01

    * Manual run:
        * Run the pipeline manually
        * Set the parameter to be "TEST PARAM"
        * The task now echos "TEST PARAM"

## Each
j Create another parameter:
    * make it an array 
    * Set it's type appropriately
    * call it "siteCodes"
    * give it the default value of : zz01, zz04, je03
       
* Use that with an each:
    * Generate a stage for each sitecode
    * echo the siteCode, like above

* TEST:
    * When ran, the pipeline should now have the inital stage + 3 new stages

## Conditional stage insertion:

* Use conditional insertion to
    * Insert an extra stage, if there's 3 values in the "siteCodes" parameter
    * This just echos "BONUS STAGE GET"

* Run the pipeline with:
    * default values           -> Should have 5 stages ( first, 3 generated, bonus )
    * test                     -> Should have 2 stages ( first and one generated one )

## Stage Conditions
* Give the stage block a condition
    * Skip a stage, if it's value is zz04

* TEST 
    * Run the pipeline with the defaults ( 3, including zz04 )
    * Note that zz04 skips
    * Note that bonus is skipped

* Run the pipeline with
    * zz01, zz09, je03         -> Should have 5 stages ( including the bonus ), and all run
    * zz01, zz04, je03         -> Should have 5 stages ( including the bonus ), 3 are run, bonus and zz04 are not

## Job status check functions
* Run the pipeline with the defaults ( including zz04 )
* Make the bonus stage RUN even if something fails, by adding a condition
    * As of right now, if something is skipped, it is skipped

* TEST:
    * Run the pipeline with defaults ( zz01, zz04, je03 )
    * The pipeline should skip the zz04 stage
    * the bonus stage should now RUN

## Templating

* Create a template:
    * for the sitecode stage
    * make it take one parameter ( being the sitecode )
    * make it a string

* Call the template from the main pipeline.yaml

* TEST:
    * There's no code in the in the each, other than declaring the use of a template
    * When the pipeline is called, it results in the same effects are before


---


# 4) Variables + templates

# Task level variables:
* Create a variable:
    * called holder
    * Is a string
    * That contains "Initial Value"

* Have a first stage, with a job, with 3 tasks:
    * task 1 : echos 
        * The variables compile time value

    * task 2 : sets variable
        * holder to "Updated Value"

    * task 3 : echos:
        * The compile time value
        * The run time value

* Test:
    * When ran:
        * Task 1 : Echo's 
            * Initial value
        * task 3 : Echos:
            * Initial Value
            * Updated Value


# Output variables and passing things around at a job level
* set the declared variable to be an output variable
* check that task 3 still echos correctly
    * It shouldn't, update it so that it does

* create the second job
* it must now echo the updated value too

* TEST:
    * when ran:
        * Job 2:
            * Can access the holder variable from the first task
            * It must echo "Updated Value"

# Output variables and passing things around at a stage level

* Create a new stage
    * With a job
    * with a task
    * That echos the value of holder, that's output from the earlier task

* TEST:
    * When ran:
        * Stage 2
        * task 1
        * Echos "Updated Value"

# Output variables and the use of templates

---


* Create:
    * A stage
        * A job

        * A job:
            * A task that echos the variables run time value
                  echo "${{ variables.holder }}"

    * A stage:
        * A task that echos the run time value

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



# Variable changes are scoped to a job level, not passed between jobs, unless you use outputs
* Setup the out variable, to pass it from Stage 1, job 1, to stage 1, job 2
    echo "##vso[task.setvariable variable=holder;isOutput=true]Updated Value"

* Update the echo task, to also keep it echoing the updated value
    * stage 1, job 1, task 3 -> Keep it echoing:
        * Initial Value
        * Updated Value

* Update stage 1, job 2, task 1 -> Have it echo the stuff

# Passing OUT variables, on a stage level
* name both stages
* make stage 2, depend on stage 1
* Declare a stage variable, called from first
* Grab the output variable from the first

# Passing OUT variables, from templates?
* Isolate the first stage into a template file
* Nothing should change, it should still continue to work fine
