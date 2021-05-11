
# Hello World:
* setup a repo
* in that repo put a "hello world" yaml
* Create a pipeline using that yaml
* Setup a build agent
    * Setup a virtual machine scale set
        * Via the portal atm
        * do this via terraform
    * Set up the agents to be used like this
    * Use terraform you scrub
    * MIGHT have to set parallel jobs to 1
* Setup the pipeline, to use this build agent
    * After building the agent, it should be available here
    * Automatically teardown vm's after use
    * You have to state that you want to use the pool that you setup, it defaults to the azure one
* Run the pipeline
    * That should happen automatically
    * might have to change the scale set to have 1 machine on standby

* Tear it all down
    * terraform destroy, should take EVERYTHING down. Scale sets, pools + pipelines
