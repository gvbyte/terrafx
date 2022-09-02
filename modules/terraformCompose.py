from time import sleep
from modules import setup
import subprocess
import shutil
import requests
from os import system, name
from main import *
import os


class BuildTF:
    def __init__(self) -> None:
        clear()
        self.SelectMenu()

    def SelectMenu(self):
        print(
            "Please select a menu option    (Ctrl + C to quit)\n\n    [1] Create new team\n\n    [2] Add dashboard to existing team\n\n    [2] Add dashboard to existing team")
        option = input("\nEnter option: ")

        self.switch(option)

    def switch(self, option):
        clear()
        if option == '1':
            self.CreateTF()
        elif option == '2':
            self.CreateTF()

    def CreateDir(self):
        self.path = f"./export/{self.final_file}"
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
        self.dash_team = input(
            "\n[*] Please enter the existing team name in Splunk\n\nTeam: ")
        self.dash_team = self.RequestTeam(self.dash_team)
        self.dash_group_name = input(
            "\n[*] Please enter dashboard group name to create\n\nDashboard Group Name: ")
        self.dash_name = input(
            "\n[*] Please enter dashboard name to create\n\nDashboard Name: ")
        self.dash_filter = input(
            "\n[*] Please enter dashboard filter to create\n\nDashboard Filter: ")
        self.final_file = input(
            "\n[*] Please enter folder name to create\n\nFolder Name: ")
        self.CreateDir()
        self.TerraformBuild("variables")
        self.TerraformBuild("providers")
        self.TerraformBuild("test")
        self.TerraformBuild("test_dash_0")
        self.TerraformBuild("main")
        self.ExecuteTF(self.final_file)

    def ExecuteTF(self, file_name):
        dir_path = os.getcwd()
        dir_path = f"{dir_path}/export/{file_name}"
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
                elif("<USER_API_KEY>" in line):
                    line = line.replace(
                        "<USER_API_KEY>", f"{setup.api_key}")
                elif("<API_URL>" in line):
                    line = line.replace(
                        "<API_URL>", f"{setup.api_url}")

                outfile.write(line)

        print(f"[!] File Created: {file}.tf")


class CopyTF:

    def __init__(self) -> None:
        # self.CheckSetup()
        self.SelectArg()

    def SelectArg(self):
        clear()
        print(
            "Please select an option to copy    (Ctrl + C to quit) \n [1] Group\n [2] Dashboard\n [3] Detector\n [4] Data Link")
        option = input("\nEnter option: ")
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
        self.final_file = input(f"Enter path name for {option}: ")
        self.CreateDir()
        subprocess.call(
            f"./modules/signalfxTerraform.py --api_url {setup.api_url} --key {setup.api_key} --name {self.final_file} --output ./{self.final_file} --{option} {self.signalfx_id}", shell=True)
        # self.BuildTf("variables")
        # self.BuildTf("providers")
        # self.BuildTf("main")

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


class BuildInfrastructure:
    def __init__(self) -> None:

        with open(f"./teams.txt", 'r') as teams:
            teams = teams.read()

        teams = teams.split("\n")

        # Executes main loop to build all teams

        for team in teams:
            print(f"\n[*] Building {team}...")
            BuildCompleteTeam(team)

        print(f"\n[!] Total teams built: {len(teams)}")


class BuildCompleteTeam:

    def __init__(self, team) -> None:
        self.original_team_name = team
        self.team_id_name = team.replace(
            " ", "").replace("-", "_").replace("(", "_").replace(")", "").replace("&", "").replace("/", "")
        self.file_path = f"./export/{self.team_id_name}"
        if(os.path.exists(self.file_path)):
            try:
                shutil.rmtree(self.file_path)
            except OSError as error:
                print(error)

        try:
            os.mkdir(self.file_path)
            print(
                f"[!] Directory Created: {self.file_path}\n\n[!] Building Terraform for {team}...")
            self.dash_name, self.dash_group_name, self.dash_filter, self.dash_team, self.team_name = team, team, team, team, team
            self.BuildTerraform("providers")
            self.BuildTerraform("variables")
            self.BuildTerraform("team")
            self.ExecuteTF(self.team_id_name)
            sleep(3)
            self.BuildTerraform("detectors")
            self.ExecuteTF(self.team_id_name)
            sleep(1)
            self.BuildTerraform("dashgroup")
            self.ExecuteTF(self.team_id_name)
            sleep(1)
            self.BuildTerraform("dashgroup_dash_0")
            self.ExecuteTF(self.team_id_name)
        except OSError as error:
            print(error)

    def BuildTerraform(self, file):
        with open(f"./template/{file}.tf", 'r') as infile, open(f"{self.file_path}/{file}.tf", "w") as outfile:
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
                elif("<USER_API_KEY>" in line):
                    line = line.replace(
                        "<USER_API_KEY>", f"{setup.api_key}")
                elif("<API_URL>" in line):
                    line = line.replace(
                        "<API_URL>", f"{setup.api_url}")
                elif("<TEMPLATE>" in line):
                    line = line.replace(
                        "<TEMPLATE>", f"{self.team_name}")
                elif("<TEAM_NAME>" in line):
                    line = line.replace(
                        "<TEAM_NAME>", f"{self.original_team_name}")
                elif("<TEAM_ID>" in line):
                    line = line.replace(
                        "<TEAM_ID>", f"{self.team_id_name}")
                elif("<EMAIL>" in line):
                    line = line.replace(
                        "<EMAIL>", f"{setup.admin_email}")
                elif("<ADMIN_TEAM_0>" in line):
                    line = line.replace(
                        "<ADMIN_TEAM_0>", setup.admin_team_id_0)
                elif("<ADMIN_TEAM_1>" in line):
                    line = line.replace(
                        "<ADMIN_TEAM_1>", setup.admin_team_id_1)

                outfile.write(line)

        print(f"\n[!] File Created: {file}.tf")

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

    def ExecuteTF(self, file_name):
        dir_path = os.getcwd()
        dir_path = f"{dir_path}/export/{file_name}"
        tf_init = subprocess.Popen(
            [f"terraform", "init"], cwd=dir_path, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        init_result = tf_init.communicate()
        print("[!] Terraform has been initiated")
        tf_apply = subprocess.Popen(
            [f"terraform", "apply", "-auto-approve"], cwd=dir_path, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        apply_result = tf_apply.communicate()
        print("[!] Terraform has been applied")
