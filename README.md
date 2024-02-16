# AWS TOGGLE CONFIG PERSONA

1. auth.config - set the value of OP_SERVICE_ACCOUNT_TOKEN
   1. If you run the script with this environmental var set OP will ask you for your credentials.
2. Run backup_aws_files_first_.sh
   1. This script will save of your primary or corporate profile so that you can toggle back to it whne you are done using AWS with your secondary profille.
3. Validate that you have a vault with the aws profile you want to toggle to and from.
4. Get the vault name, item name and categories name and set them in the auth.config file, this is so they can be in memory when script can build the path to the category values so it can go get the aws profile (persona) you are toggling to.
5. Make sure you set your OP_SERVICE_ACCOUNT_TOKEN in the auth.config file otherwise the script will ask for your credentials when it logs into the the vault.
6. Once you are done configuring the script, switch your AWS persona to the one the auth.config file points to by running deploy_my_personal_aws_persona_to_config.sh
7. This will change the values of the files the AWS CLI uses to run.
8. Once you are done using this profile (persona) you can change it back to your corp profile by running the toggle script toggle_corp_persona_back_to _aws_config.sh
   These are tiny scripts that will keep the state of you AWS CLI in the right state or the state you need it to be in when you need it to be.
