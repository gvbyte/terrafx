from dataclasses import replace
from modules import setup
import os
import platform


class Registration:

    def __init__(self) -> None:
        print("Welcome to terraFX, please continue by setting up your Splunk access\n(One Time Setup)\n\n")
        self.RegisterUser()

    def ResetSetup(self):
        self.ModifySetup(self.api_key, '<USER_API_KEY>')
        self.ModifySetup(self.api_key, '<REALM>')
        self.ModifySetup(self.api_key, '<ORG_URL>')

    def RegisterUser(self):
        attempts = 0
        while setup.api_key == '<USER_API_KEY>':
            if setup.api_key == '<USER_API_KEY>':
                self.api_key = input(
                    "\n? for help\nEnter API access token: ")
                if self.api_key == '?':
                    print(
                        "\nPerform the following in Splunk Observability UI:")
                    print(
                        "\n    1. Settings\n    2. Click name on top left corner\n    3. Show API Access Token\n    4. Copy the API access token and paste here\n")
                elif len(self.api_key) == 22:
                    print("\n[!] Valid API access token")
                    setup.api_key = self.api_key
                    self.RegisterRealm()
                    break
                else:
                    print("\n[!] API access token not valid, please try again...")
                    attempts += 1

                if attempts > 5:
                    quit()
                else:
                    continue
            else:
                break

    def RegisterRealm(self):
        attempts = 0
        while True:
            if setup.api_url == 'https://api.<REALM>.signalfx.com':
                self.api_url = input(
                    "\n? for help\nEnter realm: ")
                if self.api_url == '?':
                    print(
                        "\nPerform the following in Splunk Observability UI:")
                    print(
                        "\n    1. Settings\n    2. Click name on top left\n    3. Organization\n    4. Copy the realm (Ex. us1)\n")
                elif len(self.api_url) == 3:
                    print("\n[!] Valid realm")
                    setup.api_url = self.api_url
                    self.RegisterOrg()
                    break
                else:
                    print("\n[!] Realm not valid, please try again...")
                    attempts += 1

                if attempts > 5:
                    quit()
                else:
                    continue

    def CheckURL(self, url):
        # url = url.replace('https://', '')
        # url = url.replace('/', '')
        if (platform.system().lower()) == "windows":
            response = os.system(f"ping {url}")
        else:
            response = os.system(f"curl -I {url} | grep HTTP")
        # and then check the response...
        if response == 0:
            ping_status = True
        else:
            ping_status = False
        return ping_status

    def RegisterOrg(self):
        attempts = 0
        while True:
            if setup.org_url == '<ORG_URL>':
                self.org_url = input(
                    "\n? for help\nEnter organization url: ")
                if self.org_url == '?':
                    print(
                        "\nPerform the following in Splunk Observability UI:")
                    print(
                        '\n    1. Copy URL that is used to access Splunk and paste here\n    Ex. https://domain.signalfx.com/')
                elif self.CheckURL(self.org_url) == True:
                    print("\n[!] Valid organization url")
                    setup.org_url = self.org_url
                    self.UpdateSetup()
                    print("\n[!] Please relaunch terraFX for saved changes")
                    quit()
                else:
                    print(
                        "\n[!] Organization url not valid, please try again...")
                    attempts += 1

                if attempts > 5:
                    break
                else:
                    continue

    def UpdateSetup(self):
        self.ModifySetup("<USER_API_KEY>", self.api_key)
        self.ModifySetup("<REALM>", self.api_url)
        self.ModifySetup("<ORG_URL>", self.org_url)

    def ModifySetup(self, tag, user_input):
        with open(f"./modules/setup.py", 'r') as setup_file:
            data = setup_file.read()
            data = data.replace(tag, user_input)

            with open(f"./modules/setup.py", 'w') as setup_file:
                setup_file.write(data)

            print(
                f"\n[*] {tag} has been set")
