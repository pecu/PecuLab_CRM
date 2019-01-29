<%@page import="org.opencrx.kernel.account1.cci2.PostalAddressQuery"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Locale"%>
<%@page import="org.opencrx.kernel.account1.jmi1.Contact"%>
<%@page import="org.opencrx.kernel.account1.cci2.ContactQuery"%>
<%@page import="org.openmdx.portal.servlet.CssClass"%>
<%@page import="org.openmdx.base.naming.Path"%>
<%@page import="org.openmdx.base.accessor.jmi.cci.RefObject_1_0"%>
<%@page import="org.openmdx.portal.servlet.Texts_1_0"%>
<%@page import="org.openmdx.portal.servlet.Action"%>
<%@page import="org.openmdx.portal.servlet.ViewsCache"%>
<%@page import="org.openmdx.portal.servlet.WebKeys"%>
<%@page import="org.openmdx.portal.servlet.ApplicationContext"%>
<%@  page contentType= "text/html;charset=utf-8" language="java" pageEncoding= "UTF-8" %><%
	/**
	 * ====================================================================
	 * Project: PecuLab_CRM Description: Virtualize searching Author: David Day
	 * ====================================================================
	 */
%>
<%
	request.setCharacterEncoding("UTF-8");
	ApplicationContext app = (ApplicationContext) session.getValue(WebKeys.APPLICATION_KEY);
	ViewsCache viewsCache = (ViewsCache) session.getValue(WebKeys.VIEW_CACHE_KEY_SHOW);
	String requestId = request.getParameter(Action.PARAMETER_REQUEST_ID);
	String objectXri = request.getParameter("xri");
	if (app == null || objectXri == null || viewsCache.getView(requestId) == null) {
		response.sendRedirect(
				request.getContextPath() + "/" + WebKeys.SERVLET_NAME
		);
		return;
	}
	javax.jdo.PersistenceManager pm = app.getNewPmData();
	Texts_1_0 texts = app.getTexts();

	// get reference of calling object
	RefObject_1_0 obj = (RefObject_1_0) pm.getObjectById(new Path(objectXri));

	Path objectPath = new Path(objectXri);
	String providerName = objectPath.get(2);
	String segmentName = objectPath.get(4);

	// Get account segment
	org.opencrx.kernel.account1.jmi1.Segment accountSegment
			= (org.opencrx.kernel.account1.jmi1.Segment) pm.getObjectById(
					new Path("xri:@openmdx:org.opencrx.kernel.account1/provider/" + providerName + "/segment/" + segmentName)
			);

	String gender_str = request.getParameter("gender");
	if (gender_str == null) {
		gender_str = "";
	}
	String city_str = request.getParameter("city");
	if (city_str == null) {
		city_str = "";
	}
	String birthday_str = request.getParameter("birthday");
	if (birthday_str == null) {
		birthday_str = "";
	}

	int total, bond, high_yield;
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

    <head>
        <title>類似客戶搜尋</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0">
		<!-- Styles -->
		<link rel="stylesheet" href="../../js/bootstrap/css/bootstrap.min.css">
		<link rel="stylesheet" href="../../_style/ssf.css" >
		<link rel="stylesheet" href="../../_style/n2default.css" >
		<link rel="stylesheet" href="../../_style/colors.css">
		<link rel="stylesheet" href="../../_style/calendar-small.css">
		<link rel="stylesheet" href="../../js/wiky/wiky.css" >
		<link rel="stylesheet" href="../../js/wiky/wiky.lang.css" >
		<link rel="stylesheet" href="../../js/wiky/wiky.math.css" >
		<link rel="stylesheet" href="../../js/yui/build/assets/skins/sam/container.css" >
		<link rel="stylesheet" href="http://cdn.jsdelivr.net/chartist.js/latest/chartist.min.css">
		<link rel='shortcut icon' href='../../images/favicon.ico' >
                <style>
                    .ct-label{
                        font-size: 16px;
                    }
                </style>
		<!-- Libraries -->
		<script type="text/javascript" src="../../javax.faces.resource/jsf.js.xhtml?ln=javax.faces&amp;stage=Development"></script>	
		<script src="../../js/prototype.js"></script>
		<script src="../../js/jquery/jquery.min.js"></script>
		<script>
			$.noConflict();
		</script>
		<script src="../../js/bootstrap/js/bootstrap.min.js"></script>
		<script src="../../js/portal-all.js"></script>
		<script src="../../js/calendar/lang/calendar-en_US.js"></script>
		<!--[if lt IE 7]><script type="text/javascript" src="js/iehover-fix.js"></script><![endif]-->
		<script src="http://cdn.jsdelivr.net/chartist.js/latest/chartist.min.js"></script>
		<script language="javascript" type="text/javascript">
			var OF = null;
			try {
				OF = self.opener.OF;
			} catch (e) {
				OF = null;
			}
			if (!OF) {
				OF = new ObjectFinder();
			}
		</script>
    </head>

    <body>
        <div id="container">

			<div id="header" style="height:90px;">
				<div id="logoTable">
					<table id="headerlayout">
						<tr id="headRow">
							<td id="head" colspan="2">
								<table id="info">
									<tr>
										<td id="headerCellLeft"><img id="logoLeft" src="../../images/logoLeft.gif" alt="openCRX" title="" /></td>
										<td id="headerCellSpacerLeft"></td>
										<td id="headerCellMiddle">&nbsp;</td>
										<td id="headerCellRight"><img id="logoRight" src="../../images/logoRight.gif" alt="" title="" /></td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</div>
			</div> <!-- header -->

			<h1 style="padding: 2px;">類似客戶搜尋</h1>

			<form  accept-charset="UTF-8" method="GET" action="<%= "../.." + request.getServletPath()%>" style="padding-top:8px;">
				<input type="hidden" name="<%= Action.PARAMETER_OBJECTXRI%>" value="<%= objectXri%>">
				<input type="hidden" name="<%= Action.PARAMETER_REQUEST_ID%>" value="<%= requestId%>">
				<table class="fieldGroup">
					<tr>
						<td class="fieldLabel">城市:</td>
						<td><input type="text" name="city" class="valueL" value="<%= city_str%>" required></td>
					</tr>
					<tr>
						<td class="fieldLabel">生日:</td>
						<td><input type="text" name="birthday" id="birthday" class="valueR" value="<%= birthday_str%>" required></td>
						<td class="addon">
							<a><img class="popUpButton" id="birthday.Trigger" border="0" alt="Click to open Calendar" src="../../images/cal.gif"></a>
							<script language="javascript" type="text/javascript">
								Calendar.setup({
									inputField: "birthday",
									ifFormat: "%m/%d/%Y",
									firstDay: 0,
									timeFormat: "24",
									button: "birthday.Trigger",
									align: "Tl",
									singleClick: true,
									showsTime: true
								});
							</script>
						</td>
					</tr>
					<tr class="gridTableRow">
						<td class="fieldLabel">性別:</td>
						<td>
							<select name="gender" class="valueL" required>
								<option value="" selected disabled></option>
								<option value="0">Not given</option>
								<option value="1">Male</option>
								<option value="2">Female</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="addon">
							<input type="submit" name="go" id="go" class="<%= CssClass.btn.toString()%> <%= CssClass.btnDefault.toString()%>" title="<%= app.getTexts().getSearchText()%>" value=">>">
						</td>
					</tr>
				</table>
			</form>
			<div class="table-responsive" style="margin-top:10px;">
				<table class="table table-hover table-striped table-condensed" style="max-width:2400px;" id="G_0_0_gridTable">
					<thead>
						<tr>
							<th>類別</th>
							<th>債劵基金(比率)</th>
							<th>高收益債(比率)</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>全部</td>
							<%
								ContactQuery contactFilter = (ContactQuery) pm.newQuery(Contact.class);
								contactFilter.forAllDisabled().isFalse();
								total = accountSegment.getAccount(contactFilter).size();

								contactFilter = (ContactQuery) pm.newQuery(Contact.class);
								contactFilter.forAllDisabled().isFalse();
								contactFilter.thereExistsExtBoolean4().equalTo(true);
								bond = accountSegment.getAccount(contactFilter).size();
								bond = ((total > 0) ? bond * 100 / total : 0);

								contactFilter = (ContactQuery) pm.newQuery(Contact.class);
								contactFilter.forAllDisabled().isFalse();
								contactFilter.thereExistsExtBoolean5().equalTo(true);
								high_yield = accountSegment.getAccount(contactFilter).size();
								high_yield = ((total > 0) ? high_yield * 100 / total : 0);
							%>
							<td><div class="ct_chart"><%= bond%></div></td>
							<td><div class="ct_chart"><%= high_yield%></div></td>
						</tr>
						<% if (!gender_str.isEmpty()) { %>
						<tr>
							<td>性別</td>
							<%
								short gender = Short.parseShort(gender_str);

								ContactQuery genderFilter = (ContactQuery) pm.newQuery(Contact.class);
								genderFilter.forAllDisabled().isFalse();
								genderFilter.gender().equalTo(gender);
								total = accountSegment.getAccount(genderFilter).size();

								genderFilter = (ContactQuery) pm.newQuery(Contact.class);
								genderFilter.forAllDisabled().isFalse();
								genderFilter.gender().equalTo(gender);
								genderFilter.thereExistsExtBoolean4().equalTo(true);
								bond = accountSegment.getAccount(genderFilter).size();
								bond = ((total > 0) ? bond * 100 / total : 0);

								genderFilter = (ContactQuery) pm.newQuery(Contact.class);
								genderFilter.forAllDisabled().isFalse();
								genderFilter.gender().equalTo(gender);
								genderFilter.thereExistsExtBoolean5().equalTo(true);
								high_yield = accountSegment.getAccount(genderFilter).size();
								high_yield = ((total > 0) ? high_yield * 100 / total : 0);
							%>
							<td><div class="ct_chart"><%= bond%></div></td>
							<td><div class="ct_chart"><%= high_yield%></div></td>
						</tr>
						<% }
							if (!birthday_str.isEmpty()) { %>
						<tr>
							<td>年齡層(10年)</td>
							<%
								Date birthday, begin = new Date(), finish = new Date();
								DateFormat format = new SimpleDateFormat("MM/dd/yyyy", Locale.ENGLISH);
								birthday = format.parse(birthday_str);
								begin.setYear(birthday.getYear() / 10 * 10);
								finish.setYear((birthday.getYear() / 10 + 1) * 10);

								ContactQuery birthdayFilter = (ContactQuery) pm.newQuery(Contact.class);
								birthdayFilter.forAllDisabled().isFalse();
								birthdayFilter.thereExistsBirthdate().between(begin, finish);
								total = accountSegment.getAccount(birthdayFilter).size();

								birthdayFilter = (ContactQuery) pm.newQuery(Contact.class);
								birthdayFilter.forAllDisabled().isFalse();
								birthdayFilter.thereExistsBirthdate().between(begin, finish);
								birthdayFilter.thereExistsExtBoolean4().equalTo(true);
								bond = accountSegment.getAccount(birthdayFilter).size();
								bond = ((total > 0) ? bond * 100 / total : 0);

								birthdayFilter = (ContactQuery) pm.newQuery(Contact.class);
								birthdayFilter.forAllDisabled().isFalse();
								birthdayFilter.thereExistsBirthdate().between(begin, finish);
								birthdayFilter.thereExistsExtBoolean5().equalTo(true);
								high_yield = accountSegment.getAccount(birthdayFilter).size();
								high_yield = ((total > 0) ? high_yield * 100 / total : 0);
							%>
							<td><div class="ct_chart"><%= bond%></div></td>
							<td><div class="ct_chart"><%= high_yield%></div></td>
						</tr>
						<% }
							if (!city_str.isEmpty()) { %>
						<tr>
							<td>地區</td>
							<%
								PostalAddressQuery addressFilter = (PostalAddressQuery) pm.newQuery(org.opencrx.kernel.account1.jmi1.PostalAddress.class);
								addressFilter.forAllDisabled().isFalse();
								addressFilter.thereExistsPostalCity().like("(?i).*" + city_str + ".*");
								total = accountSegment.getAddress(addressFilter).size();

								addressFilter = (PostalAddressQuery) pm.newQuery(org.opencrx.kernel.account1.jmi1.PostalAddress.class);
								addressFilter.forAllDisabled().isFalse();
								addressFilter.thereExistsPostalCity().like("(?i).*" + city_str + ".*");
								addressFilter.account().thereExistsExtBoolean4().equalTo(true);
								bond = accountSegment.getAddress(addressFilter).size();
								bond = ((total > 0) ? bond * 100 / total : 0);

								addressFilter = (PostalAddressQuery) pm.newQuery(org.opencrx.kernel.account1.jmi1.PostalAddress.class);
								addressFilter.forAllDisabled().isFalse();
								addressFilter.thereExistsPostalCity().like("(?i).*" + city_str + ".*");
								addressFilter.account().thereExistsExtBoolean5().equalTo(true);
								high_yield = accountSegment.getAddress(addressFilter).size();
								high_yield = ((total > 0) ? high_yield * 100 / total : 0);
							%>
							<td><div class="ct_chart"><%= bond%></div></td>
							<td><div class="ct_chart"><%= high_yield%></div></td>
						</tr>
						<% }%>
					</tbody>
				</table>
			</div>
        </div> <!-- container -->
		<script>
			var charts = document.getElementsByClassName("ct_chart");
			Array.prototype.forEach.call(charts, function (element) {
				var data = {
					series: [element.innerHTML, 100 - element.innerHTML]
				};
				element.innerHTML = "";
				new Chartist.Pie(element, data, {
					labelInterpolationFnc: function (value) {
						return value + '%';
					}
				})
			});
		</script>
    </body>
</html>
