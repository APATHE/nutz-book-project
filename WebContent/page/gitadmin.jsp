<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div>
	<div>
		<span>repo列表</span>
		<div id="git_repo_list"></div>
	</div>
	<div>
		<button onclick="git_create();">新增repo</button>
	</div>
</div>


<script type="text/javascript">
	function myInit(args) {
		load_git_list();
	};
	function load_git_list() {
		$.ajax({
			url : home_base + "/admin/git/list",
			dataType : "json",
			success : function (re) {
				if (re.ok) {
					var tmp = "";
					for (var i = 0; i < re.data.length; i++) {
						var repo = re.data[i];
						console.log(repo);
						console.log(repo.name);
						tmp += "<p><h3>";
						tmp += repo.name + "      " + (repo["public"] ? "公开" : "私有");
						tmp += "</h3>";
						tmp += "  <button onclick='git_repo_delete('"+ repo.name+"');\">" + "删除" + "</button>" ;
						if (!repo["public"]) {
							tmp += "  <button onclick=\"git_repo_public('"+ repo.name+"', true);\">" + "设置为公开" + "</button>" ;
						} else {
							tmp += "  <button onclick=\"git_repo_public('"+ repo.name+"', false);\">" + "转为私有" + "</button>" ;
						}
						tmp += "</p>";
					}
					$("#git_repo_list").html(tmp);
				}
			}
		});
	};
	function git_create() {
		var git_name = prompt("请输入repo的名称,仅限英文字母/数字和下划线,长度3到20个字符");
		var re = /[a-zA-Z0-9_]{3,20}/;  
		if (git_name && re.exec(git_name)) {
			$.ajax({
				url : home_base + "/admin/git/create",
				type : "POST",
				dataType : "json",
				data : {name:git_name},
				success : function (re) {
					if (re && re.ok) {
						alert("创建成功");
					} else {
						alert(re.msg);
					}
					load_git_list();
				}
			});
		}
	};
	function git_repo_delete(repo_name) {
		$.ajax({
			url : home_base + "/admin/git/delete",
			data : {name:repo_name},
			dataType : "json",
			success : function(re) {
				if (re && re.ok) {
					load_git_list();
				} else {
					alert(re.msg);
				}
			}
		});
	};
	function git_repo_public(repo_name, is_public) {
		$.ajax({
			url : home_base + "/admin/git/update/public",
			data : {name:repo_name, "public":is_public},
			dataType : "json",
			success : function(re) {
				if (re && re.ok) {
					load_git_list();
				} else {
					alert(re.msg);
				}
			}
		});
	};
</script>