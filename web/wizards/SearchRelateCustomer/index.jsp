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
	if ( app == null || objectXri == null || viewsCache.getView(requestId) == null ) {
		response.sendRedirect(
				request.getContextPath() + "/" + WebKeys.SERVLET_NAME
		);
		return;
	}
	javax.jdo.PersistenceManager pm = app.getNewPmData();
	Texts_1_0 texts = app.getTexts();

	String searchString = (request.getParameter("searchString") == null ? "" : request.getParameter("searchString"));
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

    <head>
        <title>Search Relate Customer</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <link rel="stylesheet" href="../../js/bootstrap/css/bootstrap.min.css">	
        <link rel="stylesheet" href="../../js/chartist/chartist.min.css">	
        <link rel="stylesheet" href="../../_style/colors.css">
        <link rel="stylesheet" href="../../_style/n2default.css">
        <link rel="stylesheet" href="../../_style/ssf.css">
        <link rel="shortcut icon" href="../../images/favicon.ico">
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
			<input type="text" name="searchString" id="searchString" value="<%= searchString%>" />
			<input type="submit" name="go" id="go" class="<%= CssClass.btn.toString()%> <%= CssClass.btnDefault.toString()%>" title="<%= app.getTexts().getSearchText()%>" value=">>">
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

			    accountFilter.thereExistsPostalAddressLine().like("(?i)" + wildcard + searchString + wildcard);

			    Iterator accounts = accountSegment.getAddress(accountFilter).listIterator();
			    for ( Iterator i = accounts ; i.hasNext() && i != null ; ) {
				    org.opencrx.kernel.account1.jmi1.Account account = null;
				    org.opencrx.kernel.generic.jmi1.CrxObject crxObject = (org.opencrx.kernel.generic.jmi1.CrxObject) i.next();
				    if ( crxObject instanceof org.opencrx.kernel.account1.jmi1.Account ) {
					    account = (org.opencrx.kernel.account1.jmi1.Account) crxObject;
				    } else if ( crxObject instanceof org.opencrx.kernel.account1.jmi1.EMailAddress ) {
					    // get parent account
					    account = (org.opencrx.kernel.account1.jmi1.Account) pm.getObjectById(new Path(crxObject.refMofId()).getParent().getParent());
				    } else if ( crxObject instanceof org.opencrx.kernel.account1.jmi1.PostalAddress ) {
					    // get parent account
					    account = (org.opencrx.kernel.account1.jmi1.Account) pm.getObjectById(new Path(crxObject.refMofId()).getParent().getParent());
				    } else {
					    account = ((org.opencrx.kernel.account1.jmi1.Member) crxObject).getAccount();
				    }

				    org.opencrx.kernel.account1.jmi1.Contact contact = null;
				    if ( account instanceof org.opencrx.kernel.account1.jmi1.Contact ) {
					    contact = (org.opencrx.kernel.account1.jmi1.Contact) account;
				    }
				    if ( account == null || contact == null ) {
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
	    <div style="padding-left:12px;">Age Chart</div>
            <div class="ct-chart"></div>
        </div> <!-- container -->
	<script language="javascript" type="text/javascript" src="../../js/chartist/chartist.min.js"></script>
	<script language="javascript" type="text/javascript">
	    var data = {
		labels: ['0', '10', '20', '30', '40', '50', '60', '70', '80', '90', '100', '110'],
		series: [<%= Arrays.toString(ages)%>]
	    };

	    var options = {
		high: <%= Collections.max(Arrays.asList(ArrayUtils.toObject(ages)))%>,
		low: 0
	    };

	    new Chartist.Bar('.ct-chart', data, options);
	</script>
    </body>
</html>
