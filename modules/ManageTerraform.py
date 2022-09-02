import main
import subprocess
from os import system, name
import os


class ManageTerraform:

    def __init__(self) -> None:
        print(
            "Please select a menu option    (Ctrl + C to quit)\n\n    [1] Terraform apply all\n\n    [2] Terraform destroy all")
        option = input("\n\n\nEnter option: ")
        self.switch(option)

    def switch(self, option):
        if option == '1':
            self.TerraformApplyAll()
        elif option == '2':
            self.TerraformDestroyAll()

    def TerraformApplyAll(self):
        with open(f"./teams.txt", 'r') as teams:
            teams = teams.read()

        teams = teams.split("\n")

        # Executes main loop to build all teams

        for team in teams:
            print(f"\n[*] Terraform apply: {team}...")
            self.team_id_name = team.replace(
                " ", "").replace("-", "_").replace("(", "_").replace(")", "").replace("&", "").replace("/", "")
            self.file_path = f"./export/{self.team_id_name}"
            if(os.path.exists(self.file_path)):
                try:
                    self.TerraformApply(self.team_id_name)
                except OSError as error:
                    print(f"[!] {team} not found")

        print(f"\n[!] Total teams applied: {len(teams)}")
        main.Selection()

    def TerraformDestroyAll(self):
        with open(f"./teams.txt", 'r') as teams:
            teams = teams.read()

        teams = teams.split("\n")

        # Executes main loop to build all teams

        for team in teams:
            print(f"\n[*] Terraform destroy: {team}...")
            self.team_id_name = team.replace(
                " ", "").replace("-", "_").replace("(", "_").replace(")", "").replace("&", "").replace("/", "")
            self.file_path = f"./export/{self.team_id_name}"
            if(os.path.exists(self.file_path)):
                try:
                    self.TerraformDestroy(self.team_id_name)
                except OSError as error:
                    print(error)

        print(f"\n[!] Total teams destroyed: {len(teams)}")
        main.Selection()

    def TerraformApply(self, file_name):
        dir_path = os.getcwd()
        dir_path = f"{dir_path}/export/{file_name}"
        tf_apply = subprocess.Popen(
            [f"terraform", "apply", "-auto-approve"], cwd=dir_path, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        apply_result = tf_apply.communicate()
        print("[!] Terraform has been applied")

    def TerraformDestroy(self, file_name):
        dir_path = os.getcwd()
        dir_path = f"{dir_path}/export/{file_name}"
        tf_destroy = subprocess.Popen(
            [f"terraform", "destroy", "-auto-approve"], cwd=dir_path, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        apply_result = tf_destroy.communicate()
        print("[!] Terraform has been destroyed")
