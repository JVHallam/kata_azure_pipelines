triggers : Use?
Decide what triggers a pipeline : Name?

steps : - checkout : none : Use?
State that you don't want to checkout the repo on this job : Syntax?

----------------------------------------------------------------------- -----------------------------------------------------------------------

checkout : Occurs as the first implicit step of every JOB


# Note the syntax ${{}} for compile time and $() for runtime expressions., $[] for the pre job section variables

az pipelines pool list
az pipelines pool list --organization "https://dev.azure.com/jakehallam95" 

parameters:
- name: 'siteCodes'
  type: object
  default: ['sa01', 'zz04', 'zz09']

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

* echo "${ this shit }"

variables:
- name: string  # name of a variable
  value: string # value of the variable

Calling off to a template
stages:
- template: stages/test.yml  # Template reference
  parameters:
    name: Mini
    testFile: tests/miniSuite.js

--------------------------------------------------------------------------------
# Shit for another day, put it somewhere else

# This is a thing
resources:
  pipelines: [ pipeline ]  

resources:
  repositories:
  - repository: MyGitHubToolsRepo # The name used to reference this repository in the checkout step
    type: github
    endpoint: MyGitHubServiceConnection
    name: MyGitHubToolsOrg/tools


