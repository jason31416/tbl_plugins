<--File:main.py
import openai
import random
from lib import *

try:
	xdsa = args
except Exception:
	args = []
	usr = ""
	def setdt(a, b):
		pass
	def getdt(a):
		pass
	def setremotedt(a, b):
		pass
	def getremotedt(a):
		pass
	def run_command(a):
		pass
	tbl_print("Running in local mode!")

if len(args) >= 1 and args[0] == "gettokens":
		tbl_print(f"You used {getremotedt('tkc')} tokens in total.")
else:
	if getremotedt("openaikey") in ["_empty", ""]:
		x = tbl_input("&6mApi code: ")
		setremotedt("openaikey", x)

	getremotedt("tkc")

	openai.api_key = getremotedt("openaikey")

	if len(args) == 0:
		with open("plugins/chat/defaultprompt") as fl:
			args = [fl.read().replace("\n", " ")]

	lst = [{"role": "system", "content": " ".join(args)}]

	while True:
		cont = tbl_input("&2mHuman&7m: ")[:150]
		if cont == "stop":
			tbl_print("&4mChatGPT&7m: Goodbye!")
			break
		lst.append({"role": "user", "content": cont})
		tbl_print("\r&3mGenerating...", end="")
		try:
			ret = openai.ChatCompletion.create(
			  model="gpt-3.5-turbo",
			  messages=lst
			)
		except openai.error.AuthenticationError as e:
			tbl_print(f"\r&1mError: Your api code ({openai.api_key}) is invalid!")
			setremotedt("openaikey", "")
			break

		getremotedt("tkc")

		if getremotedt("tkc") == "_empty":
			setremotedt("tkc", "0")

		setremotedt("tkc", str(int(getremotedt("tkc"))+ret["usage"]["total_tokens"]))

		tbl_print("\r&4mChatGPT&7m: ", end="")
		ch = random.choice(ret["choices"])
		tbl_print(ch["message"]["content"])
		lst.append(ch["message"])
<--File:help.txt
chat: ChatGPT api.
type &2m"chat"&9m to start a conversation
type &2m"chat <prompt>"&9m to start a conversation using this prompt
type &2m"chat gettokens"&9m to get the current tokens spent
type &2m"stop"&9m in the conversation to end it
<--File:defaultprompt
You are a helpful assistance