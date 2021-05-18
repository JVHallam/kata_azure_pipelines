# Hello World:
* setup a repo
    * Use ado
    * in that repo put a "hello world" yaml

* Terraform a pipeline:
terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
    }
  }
}

provider "azuredevops"{
  org_service_url = "https://dev.azure.com/jakehallam95"
  personal_access_token = "dxevsvhjp7t76kodmfrb3sl2k2grjzbkyabzsidjdy4vyt7hpmyq"
}

provider "azurerm" {
    features {}
}

//This is an alternate way of getting ahold of the repository id
data "azuredevops_git_repositories" "repository" {
  project_id = data.azuredevops_project.project.id
  name       = "Infrastructure"
}

resource "azuredevops_build_definition" "pipeline" {

//az devops project list --organization https://dev.azure.com/jakehallam95/
  project_id = "b0118852-02cc-4d91-ada9-f691b3d1631e"
  name       = "Sample Build Definition"
  path       = "\\ExampleFolder"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"

    //az repos list --organization https://dev.azure.com/jakehallam95/ --project General
    repo_id     = "bfb52004-f0c4-4293-b338-fc13aa220d05"
    branch_name = "master"

    yml_path    = "main.yml"
  }
}

* Setup a build agent
    * Setup a virtual machine scale set
        * Via the portal atm
        * do this via terraform, some other time
    * Set up the agents to be used like this
    * Use terraform you scrub
    * MIGHT have to set parallel jobs to 1

This might actually be something else entirely:
* rg
* virtual net
* subnet
* azurerm_public_ip
* azurerm_lb
* azurerm_lb_backend_address_pool
* azurerm_lb_nat_pool
* azurerm_lb_probe
* azurerm_virtual_machine_scale_set

* Setup the pipeline, to use this build agent
    * After building the agent, it should be available here
    * Automatically teardown vm's after use
    * You have to state that you want to use the pool that you setup, it defaults to the azure one

    resource "azuredevops_agent_pool" "pool" {
      name           = "sample-pool"
      auto_provision = false
    }

    * add the agent to the pool 
        * this has to be done by hand

* Run the pipeline
    * Setup the yaml:
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

    * That should happen automatically
    * might have to change the scale set to have 1 machine on standby

* Tear it all down
    * terraform destroy, should take EVERYTHING down. Scale sets, pools + pipelines


* Environment variables

* Extra commands:
    * artifacts
    * logging commands


## Something else

[
    { "id": 1, "a": "avalue1"},
    { "id": 2, "a": "avalue2"},
    { "id": 3, "a": "avalue3"}
]

foo.*.id
It uses splat expressions!
