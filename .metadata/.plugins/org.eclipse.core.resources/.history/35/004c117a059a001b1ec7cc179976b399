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
		if(adminSession != null) {
			try {
				adminSession.close();
			} catch (IOException e) {}
		}
		adminSession = session;
		for (String key : ClientEchoHandler.getUserKeys()) {
			System.out.println("key : " + key);
			visit(key);
		}
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		String[] split = message.getPayload().split(":", 2);
		
		String key = split[0];
		String msg = split[1];
		
		ClientEchoHandler.send(key, msg);
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		adminSession = null;
	}
	
	// 우리가 따로 정의한 함수
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
	
	public static void msg(String key, TextMessage message) {
		send("{\"status\":\"message\", \"key\":\"" + key + "\", \"message\" :\"" + message.getPayload() + "\"}");
	}
	
	public static void bye(String key) {
		send("{\"status\":\"bye\", \"key\":\"" + key + "\"}");
	}
	
}

