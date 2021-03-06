<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
	<h3>Admin</h3>	
	<!-- 채팅 영역 -->
	<!-- 유저가 접속할 때 마다 이 container에 채팅창 생성 -->
	<h3>1:1 상담</h3>
	<div class="container">
		<div class="chat-container" style="display: none">
		<div style="height: 12px;"></div>
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
	
	sock.onopen = function(msg) {
		console.log("admin 소켓 열림");
	};
	sock.onclose = function(msg) {};
	sock.onerror = function(msg) {};
	sock.onmessage = onMessage;
	
	// 서버로부터 메세지가 오면
	// 즉, sock.send로 메세지를 받으면 이쪽으로 온다
	function onMessage(message) {
		// 메세지 구조는 JSON이다
		let node = JSON.parse(message.data);	// JSON을 js 객체로 변환
		let messageParts = new String(JSON.stringify(node.message)).split(':');
		let userName = new String(messageParts[0]).replace(/\"/g,'');			//message.date에서 받아온 JSON구조를 string으로 변환하고 그걸 잘라냄
		let content = new String(messageParts[1]).replace(/\"/g,'');
		
		
		console.log("message");				 		// JSON		웹 소켓 자체적으로 전달되는 내장 message
		console.log(message);	
		console.log("message.timeStamp");			// message 받아온 시간 		
		console.log(message.timeStamp);
		console.log("node(=message.data)");			// message에 들어있는 data (send함수에 적어넣은 값)
		console.log(node);
		console.log("JSON.stringify(node)");
		console.log(JSON.stringify(node));
		console.log("node.message");
		console.log(node.message);
		console.log("JSON.stringify(node.message)");
		console.log(JSON.stringify(node.message));
		
		
		
		$('.chat-area').scrollTop($('.chat-area')[0].scrollHeight);
		
		if(node.status === "visit") {
// 			const chatContainer = document.getElementsByClassName('chat-container').innerHTML;
			let chatContainer = $(".chat-container").html();
			chatContainer = $("<div class='chat-container2'></div>").attr("data-key", node.key).append(chatContainer);
			$(".container").append(chatContainer);
		} else if(node.status === "message") {
			let time = message.timeStamp
			console.log(time);
			let realDate = new Date(time).toLocaleString();
			console.log(realDate);
			
			let $div = $("[data-key='" + node.key + "']");
			let log = $div.find(".chat-area").text();
			if(content === "" || content === "undefined" || content === null) {
				$div.find(".chat-area").append($("<span class='chat--left'>" + userName + "</span>"));
// 				$div.find(".chat--left").text(userName + "<br>");
// 				$div.find(".chat-area").text(userName + "<br>");
			} else {
				$div.find(".chat-area").append($("<span class='chat--left'>" + 
						"<span class='chat-user'>" + userName + "</span><br>" +
						"<span class='chat-content'>" + content + "</span><br>" +
						"<span class='chat-time'>" + realDate + "</span>"));
// 				$div.find(".chat--left").text(log += userName + " :\n\t" + content + "\n");
// 				$div.find(".chat-area").text(log += userName + " :\n\t" + content + "\n");
			}
		} else if(node.status === "bye") {
			let $div = $("[data-key='" + node.key + "']");
			let log = $div.find(".chat-area").text();
			
			let totLog = JSON.stringify(log);
			console.log("totLog");
			console.log(totLog);
			
			chatInsert(totLog);
			
			
			$("[data-key='" + node.key + "']").remove();
		}
	}
	
	$(document).on("click", ".send-btn", function(message) {
		let $div = $(this).closest(".chat-container2");
		// 메세지 텍스트 박스를 찾아서 값 얻어옴()
		let msg = $div.find(".text-msg").val();
		let key = $div.data("key");
		let log = $div.find(".chat-area").text();
		
		let time = message.timeStamp
		console.log(time);
		let realDate = new Date(time).toLocaleString();
		console.log(realDate);
		console.log(log);
		$div.find(".chat-area").append($("<span class='chat--right'>" +
				"<span class='chat-user'>관리자<br>" + 
				"<span class='chat-content'>" + msg + "</span><br>" +
				"<span class='chat-time' style='margin-top: 0px'>" + realDate + "</span>"));
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
	
	const chatInsert = function(msg) {
		const ob = {
			'msg': msg
		}
		
		const json = JSON.stringify(ob);
		
		const url = '${pageContext.request.contextPath}/mongo';
		
		const opt = {
				method: 'POST',
				body: json,
				headers: {
					'Content-type': 'application/json'
				}
		}
		
		fetch(url, opt)
		.then(resp => resp.text())
		.then(row => {
			if(row == 1) {
				console.log("대화가 저장되었습니다");
			}
			else {
				console.log("저장에 실패했습니다")
			}
		});
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
</script>
</html>