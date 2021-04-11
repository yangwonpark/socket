package com.itbank.chat;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

public class ClientEchoHandler extends TextWebSocketHandler {
	
	// 서버와 유저간의 접속을 key로 구분하기 위한 인라인 클래스
	private class User {
		WebSocketSession session;
		String key;
	}

	// searchUser 함수의 filter 표현식을 위한 인터페이스
	private interface SearchExpression {
		boolean expression(User user);
	}
	
	// 유저와 서버간의 접속자 리스트
	private static List<User> sessionUsers = Collections.synchronizedList(new ArrayList<User>());
	
	// sesison으로 접속 리스트에서 User 클래스 검색
	private static User getUser(WebSocketSession session) {
		return searchUser(x -> x.session == session);
	}
	
	// Key로 접속 리스트에서 User 클래스 탐색
	private static User getUser(String key) {
		return searchUser(x -> x.key.equals(key));
	}
	
	// 접속자 리스트를 탐색하는 함수
	private static User searchUser(SearchExpression func) {
		Optional<User> op = sessionUsers.stream().filter(x -> func.expression(x)).findFirst();
		System.out.println(op);
		// 결과가 있는지 파악
		if(op.isPresent()) {
			return op.get();
		}
		return null;
	}

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		// 인라인 클래스 User 생성
		User user = new User();
		
		System.out.println("user : " + user);
		
		// Unique 키 발급(- 제거)
		user.key = UUID.randomUUID().toString().replace("-", "");
		
		// WebSocket의 세션
		user.session = session;
		
		System.out.println("user.session : " + user.session);
		System.out.println("session : " + session);
		
		// 유저 리스트에 등록
		sessionUsers.add(user);
		
		// 운영자가 Client에 유저 접속을 알린다
		AdminEchoHandler.visit(user.key);
		System.out.println("user.key : " + user.key);
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		// Session으로 접속 리스트에서 User 클래스 탐색
		User user = getUser(session);
		
		// 접속자 리스트에 User가 있는지 확인
		if(user != null) {
			AdminEchoHandler.msg(user.key, message);
		}
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		User user = getUser(session);
		if(user != null) {
			AdminEchoHandler.bye(user.key);
			sessionUsers.remove(user);
		}
	}
	
	// 운영자가 유저에게 메세지를 보내는 함수
	public static void send(String key, String message) {
		User user = getUser(key);
		TextMessage msg = new TextMessage(message);
		
		if(user != null) {
			try {
				user.session.sendMessage(msg);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	

	public static String[] getUserKeys() {
		String[] ret = new String[sessionUsers.size()];
		
		for(int i = 0; i < ret.length; i++) {
			System.out.println("sessionUsers.get(i).key : " + sessionUsers.get(i).key);
			ret[i] = sessionUsers.get(i).key;
		}
		
		return ret;
	}
	
}
