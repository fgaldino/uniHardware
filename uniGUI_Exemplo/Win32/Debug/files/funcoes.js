function uniHardwareStatus(){
	$.ajax({
	type: "GET",
	url: "http://localhost:10287/?acao=status",
	error: function(xhr, statusText) 
		{
			ajaxRequest(MainForm.form, "uniHardwareStatus", ["data=" + '{"md5":"","status":"offline","ocupado":"false"}']); 
		},
	success: function(msg)
		{
			ajaxRequest(MainForm.form, "uniHardwareStatus", ["data=" + msg]); 
		}
	}
	);
}

function SolicitaGet(){
	$.get("http://localhost:10287/", function(data, status){
		ajaxRequest(MainForm.form, "RetornoGET", ["data=" + data]);
	});				
}

function SolicitaPost(){
	$.post("http://localhost:10287/",
	{
		nome: "Fernando",
		Cidade: "Porto Nacional"
	},
	function(data, status){
		ajaxRequest(MainForm.form, "RetornoPOST", ["data=" + data]);
	});				
}


function RelatorioShowFP3(UrlFP3,AImpressora,ACopias,AEscolher){
	$.post("http://localhost:10287/",
	{
		acao: "fp3",
		url: "" + UrlFP3 + "",
		impressora: "" + AImpressora + "",
		copias: "" + ACopias + "",
		escolher: "" + AEscolher + ""
	},
	function(data, status){
		ajaxRequest(MainForm.form, "RetornoPOST", ["data=" + data]);
	});				
}

function LeituraBalanca(AModelo,APorta,ABaudRate,ADataBits,AParity,AStopBits,AHandshaking){
	$.post("http://localhost:10287/",
	{
		acao: "lerbalanca",
		modelo: "" + AModelo + "",
		porta: "" + APorta + "",
		baudrate: "" + ABaudRate + "",
		databits: "" + ADataBits + "",
		parity: "" + AParity + "",
		stopbits: "" + AStopBits + "",
		handshaking: "" + AHandshaking + ""
	},
	function(data, status){
		ajaxRequest(MainForm.form, "RetornoBalanca", ["data=" + data]);
	});				
}

function SalvarFile(UrlFile,AFileName,ADir,AFalharExitir){
	$.post("http://localhost:10287/",
	{
		acao: "SalvarFile",
		url: "" + UrlFile + "",
		filename: ""+ AFileName + "",
		dir: "" + ADir + "",
		falharexistir: "" + AFalharExitir + ""
	},
	function(data, status){
		ajaxRequest(MainForm.form, "RetornoPOST", ["data=" + data]);
	});				
}