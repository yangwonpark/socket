package com.itbank.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.itbank.service.ChatService;

@RestController
public class ChatController {
	
	@Autowired
	ChatService cs;
	
//	private ObjectMapper jm = new ObjectMapper();
	
	@PostMapping(value="mongo", consumes = "application/json; charset=utf8")
	public void insertChat(@RequestBody HashMap<String, String> map) {
		
		cs.insertChat(map);
		
	}
}
