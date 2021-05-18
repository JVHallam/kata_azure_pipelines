triggers : Use?	Decide what triggers a pipeline : Name?
steps : - checkout : none : Use?	State that you don't want to checkout the repo on this job : Syntax?
${{ value }} : Value decided when?	Rendered at compile time : What variable syntax?
$[ value ] : Value decided when?	Rendered just before a task is run : What variable syntax?
$( value ) : Value decided when?	Rendered at runtime : What variable syntax?
az pipelines pool list : Use?	List the pipeline pools : $ syntax?
az --organization "https://dev.azure.com/jakehallam95" : Use?	Set the organization flag when using az : $ Syntax
variables: - name: holder : Use?	Declare a variable called "holder" : syntax?
variables: - value: Initial Value : Use?	Declare the value of a variable : Syntax?
echo "##vso[task.setvariable variable=holder;]testvalue" : Use?	Set the value of a variable during a task : Syntax?
echo "${{ variables.holder }}" : Use?	Echo the value of a variable called holder : Syntax?
echo $(holder) : Use?	Echo the value of a variable that was set in a previous task : Syntax?
echo $(fatbutt.holder) : Use?	Echo the value of a output variable, set in a previous task : Syntax?
echo "##vso[task.setvariable variable=holder;isOutput=true]Updated Value" : Use?	Set the value of an output variable : Syntax?
- template: name.yml : Use?	Declare the use of a template : Syntax?
variables: varname: $[ dependencies.jobname.outputs['taskname.outputVarName'] ] : Use?	Set the a job variable to be equal to the output from it's dependency : Syntax?
job : variables: varname: "value" : Use?	Declare the use of a job variable : Syntax?
stage : variables: varname : $[ stageDependencies.first.run.outputs['fatbutt.myOutputVar'] ] : Use?	Declare a variable equal to a stage dependencies output variable : Syntax?
parameters: - name: 'value' : Use?	Declare a parameters name : Syntax?
parameters: - type: typeName : Use?	Declare the type of a parameter : Syntax?
parameters: - default: "value" : Use?	Declare the default value of a parameter: Syntax?
- ${{ if condition }}:  - stage: Use?	Add a stage to the file, only if a condition is met : Syntax?
- ${{ each value in parameters.values }} - job "${{value}}" : Use?	Use an each statement, to dynamically create jobs : Syntax?
condition : (eq(a,b)) : Use?	Run a stage, only if 2 values are equal : Syntax?
condition : always() : Use?	Run a stage regardless if other stages pass : Syntax?
