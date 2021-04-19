import os

def execute_command(cmd): 
    try: 
        print("Executing the commands: {}".format(cmd))
        os.system(cmd)
    except: 
        print("found error while triggering the command: {}".format(cmd))


def trigger(): 
    print("Changing the directories")
    automation_dir = os.path.join(os.getcwd(), 'infrastructure/automation')
    print("Automation directory: {}".format(automation_dir))
    os.chdir(automation_dir)

    print("Initialize the terraform")
    execute_command("terraform init")

    print("Execute the plan")
    execute_command("terraform apply --auto-approve")


if __name__ == "__main__":
    print("Starting the infrastructure deployment")

    trigger()

