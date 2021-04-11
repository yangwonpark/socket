package com.itbank.service;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Service;

@Service
public class ChatService {

	@Autowired
	private MongoTemplate mongoTemplate;
	
	public void insertChat(HashMap<String, String> map) {
		mongoTemplate.insert(map, "test");
	}
}
