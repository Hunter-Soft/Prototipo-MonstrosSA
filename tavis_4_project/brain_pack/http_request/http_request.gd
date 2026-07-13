# HTTP Request Login
extends HTTPRequest

var URL = "https://neuron5.com/api/usuario/login"#"http://ec2-54-207-52-254.sa-east-1.compute.amazonaws.com/api/usuario/login"
var URLCreate = "https://neuron5.com/api/data/create"#"http://ec2-54-207-52-254.sa-east-1.compute.amazonaws.com/api/data/create"

enum State {POST, GET, PUT, DELETE, IDLE}
var state = State.IDLE

var logged = false
var received = false
var message = ""
var userData

var json = JSON.new()

func getLogin():
	return logged
func getMessage():
	return message
func getUserData():
	return userData

func getResponse():
	return received
		
func _ready():
	state = State.POST

func save_document(file):
	var received = false
	var headers = ['Content-Type: application/json']
	var body = file
	var error = request(URLCreate, headers, HTTPClient.METHOD_POST, body)
	

func get_document() -> void:
	var headers = ['Content-Type: application/json']
	var error = request(URL, headers, HTTPClient.METHOD_GET)
	if error != OK:
		print("An error occurred in the HTTP request.")

func update_document(fields: Dictionary) -> void:
	var headers = ['Content-Type: application/json']
	var document = fields
	var jsonObject = JSON.new()
	var body = jsonObject.stringify(document)
	var error = request(URL, headers, HTTPClient.METHOD_PUT, body)
	if error != OK:
		print("An error occurred in the HTTP request.")

func delete_document() -> void:
	var headers = ['Content-Type: application/json']
	var error = request(URL, headers, HTTPClient.METHOD_DELETE)
	if error != OK:
		print("An error occurred in the HTTP request.")

func login(login: String, password: String):
	var received = false
	var headers = ['Content-Type: application/json']
	var document = {
		"login": login,
		"senha": password,
	}
	
	var body = JSON.stringify(document)
	var error = request(URL, headers, HTTPClient.METHOD_POST, body)
	
	
	#if error != OK:
	#	print("An error occurred in the HTTP request.")


func _on_request_completed(result, response_code, headers, body):
	var body_string = body.get_string_from_utf8()
	print("body: " + str(body_string))
	
	
	if response_code == 200:
		
		var json = JSON.new()
		var error = json.parse(body_string)
		if error == OK:
			var receivedData = json.data
			if typeof(receivedData) == TYPE_DICTIONARY:
				# Process the received data (assuming it's a dictionary)
				if receivedData.has("success"):
					#if received["success"]:
						userData = int(receivedData["user"]["userId"]) #int(received["user"]["userId"])
						message = "Enviado com sucesso!"
						logged = true
					#else:
					#	message = "ERRO API: Chave success está nula."
				elif receivedData.has("message"):
					message = receivedData["message"]
				else:
					message = "Dados inesperados recebidos: \n" +body_string
			else:
				message = "ERRO API: Tipo de dados inesperado recebido (não é um dicionário)."
		else:
			message = "Erro na análise JSON: " +str(json.get_error_message()) +" na linha " +str(json.get_error_line())
	else:
		message = "Requisição HTTP falhou com código de status:" +str(response_code)
		
		
	received = true
	state = State.IDLE  # Reset the state to IDLE after each operation
