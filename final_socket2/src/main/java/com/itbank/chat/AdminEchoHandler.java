package com.itbank.chat;

import java.io.IOException;

import org.springframework.stereotype.Controller;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

@Controller
public class AdminEchoHandler extends TextWebSocketHandler {
	
	// 운영자 유저는 하나 => 둘 이상의 세션에서 접속하면 마지막 세션 작동
	private static WebSocketSession adminSession = null;

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		System.out.println("admin 소켓 열림");
		if(adminSession != null) {
			try {
				adminSession.close();
			} catch (IOException e) {}
		}
		adminSession = session;
		// 사용자가 먼저 들어오고 admin의 소켓이 열릴 때만 getUserKeys() 동작
		// admin의 소켓이 먼저 열려있으면 유저가 없기 때문에 동작은 하지만 결과가 null임
		for (String key : ClientEchoHandler.getUserKeys()) {
			System.out.println("key : " + key);
			visit(key);
		}
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		System.out.println("admin 메세지 전송");
		
		String g = message.getPayload();
		System.out.println(g);
		
		
		String[] split = message.getPayload().split(":", 2);
		
		String key = split[0];
		String msg = split[1];
		
		ClientEchoHandler.send(key, msg);
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		System.out.println("admin 소켓 닫힘");
		adminSession = null;
	}
	
	// 우리가 따로 정의한 함수 (이건 User쪽에서 Admin에게 보내는 send라고 보면 됌)
	// 밑의 visit, msg, bye에서 파라미터로 받은 String 값을 이 함수에서 TextMessage로 변환
	// 변환되어 내장 함수인 sendMessage로 상대방 쪽으로 보내주고 이 때 보낸 msg가 곧 message의 data이다
	private static void send(String message) {
		TextMessage msg = new TextMessage(message);
		if(adminSession != null) {
			try {
				// WebSocketSession에 내장되어있는 함수
				adminSession.sendMessage(msg);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
	}
	
	// 유저가 접속한 것을 알려줌
	public static void visit(String key) {
		send("{\"status\":\"visit\", \"key\":\"" + key + "\"}");
	}
	
	// node.message =>
	public static void msg(String key, TextMessage message) {
		System.out.println("message : " + message);
		System.out.println("message.getPayload() : " + message.getPayload());
		send("{\"status\":\"message\", \"key\":\"" + key + "\", \"message\" :\"" + message.getPayload() + "\"}");
	}
	
	public static void bye(String key) {
		send("{\"status\":\"bye\", \"key\":\"" + key + "\"}");
	}
	
}

