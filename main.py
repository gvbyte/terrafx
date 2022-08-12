import os
import setup
import subprocess
import shutil
import requests


class copytf:

    def __init__(self) -> None:
        # self.CheckSetup()
        self.SelectArg()

    '''
    def CheckSetup(self):
        with open("./setup.py", 'w') as setup_file:
            for line in setup_file:
    '''

    def SelectArg(self):
        print(
            "Please select an option to copy: \n [1] Group\n [2] Dashboard\n [3] Detector\n [4] Data Link")
        option = input("Enter option:")
        self.switch(option)

    def switch(self, option):
        if option == '1':
            self.CreateTF("group")
        elif option == '2':
            self.CreateTF("dashboard")
        elif option == '3':
            self.CreateTF("detector")
        elif option == '4':
            self.CreateTF("globaldatalink")

    def CreateDir(self):
        self.path = f"./{self.final_file}"
        if(os.path.exists(self.path)):
            try:
                shutil.rmtree(self.path)
            except OSError as error:
                print(error)

        try:
            os.mkdir(self.path)
            print(f"[!] Created Terraform Dir: {self.final_file}")
        except OSError as error:
            print(error)

    def CreateTF(self, option):
        self.signalfx_id = input(f"Enter ID for OLD {option}: ")
        self.final_file = input(f"Enter name for NEW {option}: ")
        self.CreateDir()
        subprocess.call(
            f"./SignalfxToTerraform.py --api_url {setup.api_url} --key {setup.api_key} --name {self.final_file} --output ./{self.final_file} --{option} {self.signalfx_id}", shell=True)
        self.BuildTf("variables")
        self.BuildTf("providers")
        self.BuildTf("main")

    def ExecuteTF(self, file_name):
        process = subprocess.Popen(
            [f"ls ./{file_name}"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        result = process.communicate()
        print(result)

    def BuildTf(self, file):
        with open(f"./template/{file}.tf", 'r') as infile, open(f"{self.path}/{file}.tf", "w") as outfile:
            for line in infile:
                if("<DASH_NAME>" in line):
                    line = line.replace(
                        "<DASH_NAME>", f"{self.final_file}")
                outfile.write(line)

        print(f"[!] Created {file}.tf under {self.path}")


class buildtf:
    def __init__(self) -> None:
        self.SelectMenu()

    def SelectMenu(self):
        print(
            "Please select a menu option: \n [1] Build group and dashboard")
        option = input("Enter option:")
        self.switch(option)

    def switch(self, option):
        if option == '1':
            self.CreateTF()

    def CreateDir(self):
        self.path = f"./{self.final_file}"
        if(os.path.exists(self.path)):
            try:
                shutil.rmtree(self.path)
            except OSError as error:
                print(error)

        try:
            os.mkdir(self.path)
            print(f"[!] Directory Created: {self.final_file}")
        except OSError as error:
            print(error)

    def RequestTeam(self, team_name):

        h = {'X-SF-TOKEN': f'{setup.api_key}'}
        r = requests.get(f"{setup.api_url}/v2/team", headers=h)
        if r.status_code == 200:
            for item in r.json()['results']:
                request_team = item['name']
                request_id = item['id']
                # print(request_team)
                # print(request_id)
                if(team_name.lower() == request_team.lower()):
                    # print(item['id'])
                    return item['id']

        elif r.status_code == 401:
            print("[!] Unauthorized, please check api_key or api_url in ./setup.py")

        print("[!] Team not found! Please try again.")
        self.CreateTF()

    def CreateTF(self):
        self.dash_team = input("Team: ")
        self.dash_team = self.RequestTeam(self.dash_team)
        self.dash_group_name = input("Dashboard Group Name: ")
        self.dash_name = input("Dashboard Name: ")
        self.dash_filter = input("Dashboard Filter: ")
        self.final_file = input("Folder Name: ")
        self.CreateDir()
        self.TerraformBuild("variables")
        self.TerraformBuild("providers")
        self.TerraformBuild("test")
        self.TerraformBuild("test_dash_0")
        self.TerraformBuild("main")
        self.ExecuteTF(self.final_file)

    def ExecuteTF(self, file_name):
        dir_path = os.getcwd()
        dir_path = f"{dir_path}/{file_name}"
        tf_init = subprocess.Popen(
            [f"terraform", "init"], cwd=dir_path, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        init_result = tf_init.communicate()
        print("[!] Terraform has been initiated")
        tf_apply = subprocess.Popen(
            [f"terraform", "apply", "-auto-approve"], cwd=dir_path, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        apply_result = tf_apply.communicate()
        print("[!] Terraform has been applied")
        # print(result)

    def TerraformBuild(self, file):
        with open(f"./template/{file}.tf", 'r') as infile, open(f"{self.path}/{file}.tf", "w") as outfile:
            for line in infile:
                if("<DASH_NAME>" in line):
                    line = line.replace(
                        "<DASH_NAME>", f"{self.dash_name}")
                elif("<DASH_GROUP_NAME>" in line):
                    line = line.replace(
                        "<DASH_GROUP_NAME>", f"{self.dash_group_name}")
                elif("<DASH_FILTER>" in line):
                    line = line.replace(
                        "<DASH_FILTER>", f"{self.dash_filter}")
                elif("<DASH_TEAM>" in line):
                    line = line.replace(
                        "<DASH_TEAM>", f"{self.dash_team}")

                outfile.write(line)

        print(f"[!] File Created: {file}.tf")


class menus:

    def __init__(self) -> None:
        self.SelectMenu()

    def SelectMenu(self):
        print(
            "Please select a menu option: \n [1] Build TF from template\n [2] Copy TF from ID")
        option = input("Enter option:")
        self.switch(option)

    def switch(self, option):
        if option == '1':
            terrafx = buildtf()
        elif option == '2':
            terrafx = copytf()


terrafx = menus()