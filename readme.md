
# Things to do:
* Get a pipeline running, with a trigger, that just echos "hello world"
* The build directory:
    * echo $(Build.SourcesDirectory)
    * where everything is started
* Clone a second repo into the agent
    * https://docs.microsoft.com/en-us/azure/devops/pipelines/repos/multi-repo-checkout?view=azure-devops
    resources:
      repositories:
      - repository: DevOps #How we refer to this repo later on
        type: git
        name: DevOps #repo name in azure

    stages:
    - stage: setup
      jobs:
      - job: clone_the_repos
        steps:
        - checkout : self
        - checkout : DevOps

    * there's also checking out none
        - checkout : none

* Build agents and jobs:
    * You can specify the pools at the start of a job

* Environment variables
    * passing variables between jobs
    * setting environment variables that can be passed between jobs / stages

* Artifacts
    * pushing artifacts
    * pulling artifacts
    * permanent artifacts?
