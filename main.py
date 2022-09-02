
from os import system, name
from modules import terraformCompose
from modules import registration
from modules import setup
from modules import ManageTerraform


def clear():
    if name == 'nt':
        _ = system('cls')

    else:
        _ = system('clear')


class Selection:

    def __init__(self) -> None:
        clear()
        if setup.api_key == '<USER_API_KEY>':
            registration.Registration()
        else:
            self.SelectMenu()

    def SelectMenu(self):
        print(
            "Please select a menu option    (Ctrl + C to quit)\n\n    [1] Build terraform from template(s)\n\n    [2] Copy terraform from Splunk ID\n\n    [3] Build infrastructure from teams.txt\n\n    [4] Manage terraform in /export")
        option = input("\n\n\nEnter option: ")
        self.switch(option)

    def switch(self, option):
        if option == '1':
            clear()
            terraformCompose.BuildTF()
        elif option == '2':
            clear()
            terraformCompose.CopyTF()
        elif option == '3':
            clear()
            terraformCompose.BuildInfrastructure()
        elif option == '4':
            clear()
            ManageTerraform.ManageTerraform()


if __name__ == '__main__':
    Selection()
