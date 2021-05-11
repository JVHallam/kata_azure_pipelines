* Prio
    * Hello world
    * With trigger
    * Terraforming a pipeline
    * Stages and structure

    * Logic
    * Passing variables between jobs, stages, etc.
        * Environment variables
    * Git repos

    * Artifacts
    * Using particular tools
        * Terraform 
        * AZ
        * Kubernetes
        * Docker
    * 2 Repos, one yaml file

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
    * You can specify the pools at the start of a job, so you can flip between agents
    pool:
      name: 'Mobius'
      demands:
      - Agent.os -equals linux

* Github:
    * github actions
    * just pulling from github itself

* Environment variables
    * passing variables between jobs
    * setting environment variables that can be passed between jobs / stages

* Artifacts
    * pushing artifacts
    * pulling artifacts
    * permanent artifacts?

* Passing values around between jobs:
    $sac = terraform output storage_account_name;
    $sc = terraform output container_name;
    echo "##vso[task.setvariable variable=storage_account_name]$($sac)"
    echo "##vso[task.setvariable variable=container_name]$($sc)"

* terraform's ado provider:
    * Creating a pipeline, using terraform

* running remote terraform state from the pipeline
    * You can't just have the provider in the main.tf file, it needs to be in the pipeline
    * Can you put this in the .tfvars file instead? - so that it's in the repo and the pipeline


# https://github.com/arunksingh16/devops/blob/master/pipelines/passing_variable_stage.yml

* This is a fucking gold mine of information!

stages:
- stage: STAGE_X
  jobs:
  - job: STAGE_X_JOB_A
    steps:
    - checkout: none
    - script: |
        echo "##vso[task.setvariable variable=VarKey;isOutput=true]beans"
      name: ValidateVar

    - script: |
        echo "Key Value :"
        echo $(ValidateVar.VarKey)
      name: Print_Key_value

  - job: STAGE_X_JOB_B
    dependsOn: STAGE_X_JOB_A
    condition: eq(dependencies.STAGE_X_JOB_A.outputs['ValidateVar.VarKey'], 'TEST')
    steps:
    - checkout: none
    - script: |
        echo "This is job STAGE_X_JOB_B and will run as per the valid condition"
      displayName: Print Details

- stage: STAGE_Y
  dependsOn: STAGE_X
  jobs:
  - job: STAGE_Y_JOB_B
    condition: eq(stageDependencies.STAGE_X.STAGE_X_JOB_A.outputs['ValidateVar.VarKey'], 'TEST') 
    variables:
      varFromStageA: $[ stageDependencies.STAGE_X.STAGE_X_JOB_A.outputs['ValidateVar.VarKey'] ]
    steps:
    - checkout: none
    - script: |
        echo "This Job will print value from Stage STAGE_X"
        echo $(varFromStageA)

* Ephemeral agents:
    * have a network that can't be contacted by anything from outside it
    * create an agent, in that network
    * make sure that agent can do the job
    * make sure a normal cloud agent can't
