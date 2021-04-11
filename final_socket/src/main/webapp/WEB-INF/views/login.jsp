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
	<form method="POST">
		<div style="width: 100%">
			<div style="margin: auto">
				<input type="text" name="userid">
				<input type="text" name="userpw">
			</div>
			<div>
				<input type="submit" value="로그인">
			</div>
		</div>
	</form>
</body>
</html>