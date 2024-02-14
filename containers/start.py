#!/usr/bin/env python3

import os
import subprocess

print("\nStarting up a container.")
print("Choose which container to start from the files: \n")

script_location = os.path.dirname(os.path.abspath(__file__))
files = os.listdir(script_location)

for i, file in enumerate(files): 
    if file.endswith(".py"):
        continue
    print(f"{i}: {file}")

try:
    while True:
        chosen_file_by_index = input("\nWhich container do you want to start? (Enter number):  ")

        # input_too_long = len(chosen_file_by_index) > len(str(len(files)))
        # if input_too_long:
        #     print("Invalid file chosen. Try again.")

        try:
            chosen_file_name = files[int(chosen_file_by_index)]
        except IndexError as e:
            print(f"Invalid input. Try again.")

        break
except: 
    print("\n\nAborted")
    sys.exit(1)

result = subprocess.run(["sudo", "docker", "compose", "-f", chosen_file_name, "up"], capture_output=True, text=True)
if (result.returncode == 0):
    print("Docker container(s) for {chosen_file_name} spun up successfully.")
