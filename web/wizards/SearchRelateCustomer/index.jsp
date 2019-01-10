<%@page import="org.apache.commons.lang.ArrayUtils"%>
<%@  page contentType= "text/html;charset=utf-8" language="java" pageEncoding= "UTF-8" %><%
	/**
	 * ====================================================================
	 * Project: PecuLab_CRM Description: Virtualize searching Author: David Day
	 * ====================================================================
	 */
%>
<%@ page session="true" import="
         java.util.*,
         java.io.*,
         java.text.*,
         java.math.*,
         java.net.*,
         java.sql.*,
         javax.naming.Context,
         javax.naming.InitialContext,
         org.openmdx.kernel.id.cci.*,
         org.openmdx.kernel.id.*,
         org.opencrx.kernel.portal.*,
         org.openmdx.base.accessor.jmi.cci.*,
         org.openmdx.base.exception.*,
         org.openmdx.portal.servlet.*,
         org.openmdx.portal.servlet.attribute.*,
         org.openmdx.portal.servlet.component.*,
         org.openmdx.portal.servlet.control.*,
         org.openmdx.portal.servlet.wizards.*,
         org.openmdx.base.naming.*,
         org.openmdx.base.query.*,
         org.openmdx.base.text.conversion.*,
         org.openmdx.kernel.log.*,
         org.apache.poi.hssf.usermodel.*,
         org.apache.poi.hssf.util.*
         " %>
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
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

    <head>
        <title>Search Relate Customer</title>
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
		<link rel='shortcut icon' href='../../images/favicon.ico' >
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

				<div id="etitle" style="height:20px;padding-left:12px;">Search Relate Customer</div>

				<div id="topnavi">

					<form  accept-charset="UTF-8" method="GET" action="<%= "../.." + request.getServletPath()%>" style="padding-top:8px;">
						<input type="hidden" name="<%= Action.PARAMETER_OBJECTXRI%>" value="<%= objectXri%>">
						<input type="hidden" name="<%= Action.PARAMETER_REQUEST_ID%>" value="<%= requestId%>">
						<table class="fieldGroup">
							<tr>
								<td class="fieldLabel">城市:</td>
								<td><input type="text" name="city" class="valueL" required></td>
							</tr>
							<tr>
								<td class="fieldLabel">生日:</td>
								<td><input type="text" name="birthday" id="birthday" class="valueR" required></td>
								<td class="addon">
									<a><img class="popUpButton" id="birthday.Trigger" border="0" alt="Click to open Calendar" src="../../images/cal.gif"></a>
									<script language="javascript" type="text/javascript">
										Calendar.setup({
											inputField: "birthday",
											ifFormat: "%m/%d/%Y %I:%M:%S %p",
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
										<option value="" disabled selected>請選擇性別</option>
										<option value="male">Male</option>
										<option value="female">Female</option>
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
				</div> <!-- topnavi -->

			</div> <!-- header -->

			<div id="content-wrap">
				<div id="content" style="padding:13.5em 0.5em 0px 0.5em;">

					<%
						// Data for Chart
						int[] ages = new int[12];

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

						final String wildcard = ".*";

						org.opencrx.kernel.account1.cci2.PostalAddressQuery accountFilter = (org.opencrx.kernel.account1.cci2.PostalAddressQuery) pm.newQuery(org.opencrx.kernel.account1.jmi1.PostalAddress.class);
						accountFilter.forAllDisabled().isFalse();

						accountFilter.thereExistsPostalAddressLine().like("(?i)" + wildcard + "" + wildcard);

						Iterator accounts = accountSegment.getAddress(accountFilter).listIterator();
						for (Iterator i = accounts; i.hasNext() && i != null;) {
							org.opencrx.kernel.account1.jmi1.Account account = null;
							org.opencrx.kernel.generic.jmi1.CrxObject crxObject = (org.opencrx.kernel.generic.jmi1.CrxObject) i.next();
							if (crxObject instanceof org.opencrx.kernel.account1.jmi1.Account) {
								account = (org.opencrx.kernel.account1.jmi1.Account) crxObject;
							} else if (crxObject instanceof org.opencrx.kernel.account1.jmi1.EMailAddress) {
								// get parent account
								account = (org.opencrx.kernel.account1.jmi1.Account) pm.getObjectById(new Path(crxObject.refMofId()).getParent().getParent());
							} else if (crxObject instanceof org.opencrx.kernel.account1.jmi1.PostalAddress) {
								// get parent account
								account = (org.opencrx.kernel.account1.jmi1.Account) pm.getObjectById(new Path(crxObject.refMofId()).getParent().getParent());
							} else {
								account = ((org.opencrx.kernel.account1.jmi1.Member) crxObject).getAccount();
							}

							org.opencrx.kernel.account1.jmi1.Contact contact = null;
							if (account instanceof org.opencrx.kernel.account1.jmi1.Contact) {
								contact = (org.opencrx.kernel.account1.jmi1.Contact) account;
							}
							if (account == null || contact == null) {
								continue;
							}

							long account_age = System.currentTimeMillis() - contact.getBirthdate().getTime();
							Calendar c = Calendar.getInstance();
							c.setTimeInMillis(account_age);
							ages[(c.get(Calendar.YEAR) - 1970) / 10]++;
						}
					%>
				</div> <!-- content -->
			</div> <!-- content-wrap -->
        </div> <!-- container -->
    </body>
</html>
