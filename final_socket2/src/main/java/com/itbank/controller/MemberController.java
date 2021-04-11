package com.itbank.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.itbank.member.MemberDTO;
import com.itbank.service.MemberService;

@Controller
public class MemberController {
	
	@Autowired
	MemberService ms;
	
	@RequestMapping("login")
	public void login() {
		
	}
	
	@RequestMapping(value="login", method=RequestMethod.POST)
	public String login(MemberDTO dto, HttpSession session) {
		MemberDTO login = ms.getMember(dto);
		session.setAttribute("login", login);
		
		return "redirect:/";
	}
	
	@RequestMapping(value="logout", method=RequestMethod.GET)
	public String logout(HttpSession session) {
		session.invalidate();
		
		return "redirect:/";
	}
	
	
	
	
	
	
	
	
	
}
