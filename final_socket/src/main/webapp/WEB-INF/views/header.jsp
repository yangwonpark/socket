<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cpath">${pageContext.request.contextPath }</c:set>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Websocket - final</title>
</head>
<link rel="stylesheet" href="${cpath }/resources/css/chat.css">
<script
        src="https://code.jquery.com/jquery-3.6.0.min.js"
        integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
        crossorigin="anonymous">
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.js"></script>
</head>
<body>
	<h1>웹 소켓 연습 - final</h1>
	<hr>
	<c:if test = "${login == null }">
		<a href="${cpath }/login" style="text-decoration: none; color: black;">로그인</a>
	</c:if>	
	<c:if test = "${login != null }">
		<a href="${cpath }/logout" style="text-decoration: none; color: black;">로그아웃</a>
		<c:if test="${login.userid == 'admin' }">
		<a href="${cpath }/admin" style="text-decoration: none; color: black;">관리자</a>
		</c:if>
		<c:if test="${login.userid != 'admin' }">
			<a href="${cpath }/client" style="text-decoration: none; color: black;">사용자</a>
		</c:if>
	</c:if>	

	
	
