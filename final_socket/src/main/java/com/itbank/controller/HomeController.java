package com.itbank.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class HomeController {
	
	@RequestMapping(value="", method = RequestMethod.GET)
	public String home() {
		return "home";
	}
	
	@RequestMapping(value="client", method=RequestMethod.GET)
	public String client() {
		return "client";
	}

	@RequestMapping(value="admin", method=RequestMethod.GET)
	public String admin() {
		return "admin";
	}
}
