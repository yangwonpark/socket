<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
	<h3>Admin</h3>	
	<!-- 채팅 영역 -->
	<!-- 유저가 접속할 때 마다 이 container에 채팅창 생성 -->
	<h3>1:1 상담</h3>
	<div class="container">
		<div class="chat-container" style="display: none">
			<!-- 서버와 메세지를 주고 받을 텍스트 영역 -->
			<div class="chat-area"></div>
			<div class="input--text">
				<input class="text-msg" type="text" onkeydown="if(event.keyCode === 13) return false;">
				<input type="button" class="send-btn" value="전송">
			</div>
			<br/>
		</div>
	</div>
</body>
<script>
	let sock = new SockJS('http://172.30.1.58:8080/park/adminEcho');
	
	sock.onopen = function(msg) {};
	sock.onclose = function(msg) {};
	sock.onerror = function(msg) {};
	sock.onmessage = onMessage;
	
	// 서버로부터 메세지가 오면
	function onMessage(message) {
		// 메세지 구조는 JSON이다
		let node = JSON.parse(message.data);
		
		let messageParts = new String(JSON.stringify(node.message)).split(':');
		let userName = new String(messageParts[0]).replace(/\"/g,'');
		let content = new String(messageParts[1]).replace(/\"/g,'');
		
		$('.chat-area').scrollTop($('.chat-area')[0].scrollHeight);
		
		if(node.status === "visit") {
// 			const chatContainer = document.getElementsByClassName('chat-container').innerHTML;
			let chatContainer = $(".chat-container").html();
			chatContainer = $("<div class='chat-container2'></div>").attr("data-key", node.key).append(chatContainer);
			$(".container").append(chatContainer);
		} else if(node.status === "message") {
			let $div = $("[data-key='" + node.key + "']");
			let log = $div.find(".chat-area").text();
			if(content === "" || content === "undefined" || content === null) {
				$div.find(".chat-area").append($("<span class='chat--left'>" + userName + "</span>"));
// 				$div.find(".chat--left").text(userName + "<br>");
// 				$div.find(".chat-area").text(userName + "<br>");
			} else {
				$div.find(".chat-area").append($("<span class='chat--left'>" + userName + "<br>" + content + "</span>"));
// 				$div.find(".chat--left").text(log += userName + " :\n\t" + content + "\n");
// 				$div.find(".chat-area").text(log += userName + " :\n\t" + content + "\n");
			}
			
		} else if(node.status === "bye") {
			$("[data-key='" + node.key + "']").remove();
		}
	}
	
	$(document).on("click", ".send-btn", function() {
		let $div = $(this).closest(".chat-container2");
		// 메세지 텍스트 박스를 찾아서 값 얻어옴()
		let msg = $div.find(".text-msg").val();
		let key = $div.data("key");
		let log = $div.find(".chat-area").text();
		console.log(log);
		$div.find(".chat-area").append($("<span class='chat--right'> 관리자 <br> " + msg + "</span>"));
// 		$div.find(".chat-area").text(log + "관리자" + " : " + msg + "\n");
		$div.find(".text-msg").val("");
		
		sock.send(key + ":" + msg);
	});
	
	
	// 엔터키 입력 시 sendMessage() 호출
	$(document).on("keydown", ".text-msg", function() {
		if(event.keyCode === 13) {
			$(this).closest(".chat-container2").find(".send-btn").trigger("click");
			return false;	
		}
		return true;
	});
		
// 	$(function() {
// 		let isScrollUp = false;
// 		let lastScrollTop;
	
// 		let chatArea = document.getElementsByClassName('chat-area');
		
// 		if(!isScrollUp) {
// 			$('.chat-area').animate({
// 				scrollTop: chatArea.scrollHeight - chatArea.clientHeight
// 			}, 100);
// 		}
// 	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
</script>
</html>