<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
	<h3>Client</h3>	
	<!-- 채팅 영역 -->
	<div class="container">
		<div id="user-container" class="chat-container2" style="display: none">
			<!-- 서버와 메세지를 주고 받을 텍스트 영역 -->
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
	
	function onMessage(m) {
		console.log(m);
		console.log(m.data);
		chatArea.innerHTML += "<span class='chat--left'>관리자 <br>&emsp;" + m.data + "</span><br>"
	}
	
	function onClose() {};
	
	function sendMessage() {
		const liveName = document.getElementById('name').value;
		
		chatArea.innerHTML += "<span class='chat--right'>" +liveName + "<br>" + textMsg.value + "</span><br>";
		
		console.log(textMsg.value);
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