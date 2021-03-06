<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
	<h3>Client</h3>	
	<!-- 채팅 영역 -->
	<div class="container">
		<div id="user-container" class="chat-container2" style="display: none">
			<!-- 서버와 메세지를 주고 받을 텍스트 영역 -->
			<div style="height: 12px;"></div>
			<div class="chat-area"></div>
			<div class="input--text">
				<input class="text-msg" type="text" onkeydown="return enter()">
				<input type="button" class="send-btn" value="전송">
			</div>
		</div>
		<br/>		
		<div id="enter-container">
			<input disabled="disabled" type="hidden" id="name" style="border: none; background: none;" value="${login.name }">
			<button id="enter-btn" class="btn-qa">1:1 문의</button>
		</div>
	</div>
<script>
	const chatArea = document.querySelector(".chat-area");
// 	const chatArea = document.getElementById("chat-area");
	const enterBtn = document.getElementById("enter-btn");
	const sendBtn = document.querySelector(".send-btn");
// 	const sendBtn = document.getElementById("send-btn");
	const chatContainer = document.querySelector(".chat-container2")
// 	const chatContainer = document.getElementById("chat-container")
	const textMsg = document.querySelector('.text-msg');
// 	const textMsg = document.getElementById('text-msg');
	const btnQa = document.querySelector('.btn-qa');
	
	let toggleCheck = false;
	
	// enterBtn click이벤트 최초 실행 후 이벤트 기능 상실
	// onclick보다 addEventListener가 더 최신 문법이다...
	enterBtn.addEventListener('click', function(e) {
		console.log(e.target.previousElementSibling.value);
		connect(e.target.previousElementSibling.value);
	}, {once : true});
	
	
	btnQa.onclick = (e) => {
		if(toggleCheck) {
			toggleCheck = false;
			chatContainer.style.display = 'none';
		} else {
			toggleCheck = true;
			chatContainer.style.display = 'block';
		}
	}
	
	sendBtn.onclick = (e) => {
		sendMessage();
	}
	
	let sock;
	
	function connect(name) {
		sock = new SockJS('http://172.30.1.58:8080/park/clientEcho');
		// 웹 소켓 자체에 내장 메소드 4개 
		sock.onopen = onOpen;
		sock.onmessage = onMessage;
		sock.onclose = onClose;
		sock.onerror = onError;
	}
	
	function onOpen() {
		const name = document.getElementById('name').value;
		console.log(name);
// 		chatContainer.style.display = 'block';
		// 웹소켓 내장 메소드
// 		sock.send(name + "님 입장");
		chatArea.innerHTML = "";
	}
	
	function onError() {
		chatArea.innerHTML += "연결에 실패했습니다. <br> 재접속 하세요";
	}
	
	function onMessage(message) {
// 		let node = JSON.parse(message.data);
		
		console.log("message");				 		// JSON		웹 소켓 자체적으로 전달되는 내장 message
		console.log(message);				 		
// 		console.log(message);	
// 		console.log("message.timeStamp");			// message 받아온 시간 		
// 		console.log(message.timeStamp);
// 		console.log("node(=message.data)");			// message에 들어있는 data (send함수에 적어넣은 값)
// 		console.log(node);
// 		console.log("JSON.stringify(node)");
// 		console.log(JSON.stringify(node));
// 		console.log("node.message");
// 		console.log(node.message);
// 		console.log("JSON.stringify(node.message)");
// 		console.log(JSON.stringify(node.message));
		
		let time = message.timeStamp
		let realDate = new Date(time).toLocaleString();
		console.log(realDate);
		
		chatArea.innerHTML += "<span class='chat--left'>" +
			"<span class='chat-user'>관리자<br>" +
// 			"<span class='chat-content'>" + message.data + "</span><br>"
			"<span class='chat-content'>" + message.data + "</span>"
// 			"<span class='chat-time'>" + realDate + "</span>";
	}
	
	function onClose() {};
	
	// 이 함수가 가지고 있는 sock.send가 맞은편 소켓의 대상의 onMessage와 연결되어있다고 보면 됌
	function sendMessage(message) {
		const liveName = document.getElementById('name').value;
		
		console.log(message);
		
// 		let time = message.timeStamp
// 		let realDate = new Date(time).toLocaleString();
// 		console.log(realDate);
		
		chatArea.innerHTML += "<span class='chat--right'>" + 
		"<span class='chat-user'>" + liveName + "<br>" +
		"<span class='chat-content'>" + textMsg.value + "</span><br>"
// 		"<span class='chat-time'>" + realDate + "</span>";
		
		console.log(textMsg.value);
		// liveName(회원 이름)과 textMsg.value(텍스트 내용)를 :로 엮어서 넘겨줌
		//
		sock.send(liveName + ":" + textMsg.value);
		
		textMsg.value = "";
	}
	
	function enter() {
		if(event.keyCode == 13) {
			sendMessage();
			return false;
		}
		return true;
	}
	
	
	
</script>


</body>
</html>