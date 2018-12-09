<%@ page contentType= "text/html;charset=UTF-8" language="java" pageEncoding= "UTF-8" %><%
/*
 * ====================================================================
 * Project:     openMDX/Portal, http://www.openmdx.org/
 * Description: edit-Default.jsp
 * Owner:       OMEX AG, Switzerland, http://www.omex.ch
 * ====================================================================
 *
 * This software is published under the BSD license
 * as listed below.
 *
 * Copyright (c) 2004-2014, OMEX AG, Switzerland
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or
 * without modification, are permitted provided that the following
 * conditions are met:
 *
 * * Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in
 * the documentation and/or other materials provided with the
 * distribution.
 *
 * * Neither the name of the openMDX team nor the names of its
 * contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * ------------------
 *
 * This product includes software developed by the Apache Software
 * Foundation (http://www.apache.org/).
 *
 * This product includes software developed by Mihai Bazon
 * (http://dynarch.com/mishoo/calendar.epl) published with an LGPL
 * license.
 */
%><%@ page session="true" import="
		   java.util.*,
		   java.text.*,
		   java.math.*,
		   org.openmdx.portal.servlet.*,
		   org.openmdx.portal.servlet.component.*,
		   org.openmdx.portal.servlet.control.*,
		   org.openmdx.base.naming.*
" %><%
	ApplicationContext app = (ApplicationContext)session.getValue(WebKeys.APPLICATION_KEY);
	ViewsCache viewsCache = (ViewsCache)session.getValue(WebKeys.VIEW_CACHE_KEY_EDIT);
	EditObjectView view = (EditObjectView)viewsCache.getView(request.getParameter(Action.PARAMETER_REQUEST_ID));
	Texts_1_0 texts = app.getTexts();
	EditInspectorControl inspectorControl = (EditInspectorControl)view.getControl();
	ViewPort p = ViewPortFactory.openPage(
		view,
		request,
		out
	);

	// Prolog
	Control prolog = view.createControl(
		"prolog",
		PagePrologControl.class
	);

	// Epilog
	Control epilog = view.createControl(
		"epilog",
		PageEpilogControl.class
	);

	// Session info
	Control north = view.createControl(
		"north",
		SessionInfoControl.class
	);

	// STANDARD
	if(view.getMode() == ViewMode.STANDARD) {
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html dir="<%= texts.getDir() %>">
	<head>
		<%
			String objectTitle = view.getObjectReference().getTitle();
			if(objectTitle == null) objectTitle = "#NULL";
		%>
		<title><%= app.getApplicationName() + " - " + objectTitle + (objectTitle.length() == 0 ? "" : " - ") + view.getObjectReference().getLabel() %></title>
		<%
			prolog.paint(p, PagePrologControl.FRAME_PRE_PROLOG, false);
			p.flush();
		%>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=<%= app.getInitialScale() %>">

		<!-- Styles -->
		<link rel="stylesheet" href="js/bootstrap/css/bootstrap.min.css">
		<link rel="stylesheet" href="_style/ssf.css" >
		<link rel="stylesheet" href="_style/n2default.css" >
		<link rel="stylesheet" href="_style/colors.css">
		<link rel="stylesheet" href="_style/calendar-small.css">
		<link rel="stylesheet" href="js/wiky/wiky.css" >
		<link rel="stylesheet" href="js/wiky/wiky.lang.css" >
		<link rel="stylesheet" href="js/wiky/wiky.math.css" >
		<link rel="stylesheet" href="js/yui/build/assets/skins/sam/container.css" >
		<link rel='shortcut icon' href='images/favicon.ico' />

		<!-- Libraries -->
		<script src="js/prototype.js"></script>
		<script src="js/jquery/jquery.min.js"></script>
		<script>
			$.noConflict();
		</script>
		<script src="js/bootstrap/js/bootstrap.min.js"></script>
		<script src="js/polymer/components/webcomponentsjs/webcomponents-lite.min.js"></script>    
		<script src="js/portal-all.js"></script>
		<script src="js/calendar/lang/calendar-<%= app.getCurrentLocaleAsString() %>.js"></script>
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
		<%
			prolog.paint(p, PagePrologControl.FRAME_POST_PROLOG, false);
			p.flush();
		%>
	</head>
	<body onload="initPage();">
		<iframe class="<%= CssClass.popUpFrame %>" id="DivShim" src="blank.html" scrolling="no" frameborder="0" style="position:absolute; top:0px; left:0px; display:none;"></iframe>
			<%
				if(view.getMode() == ViewMode.STANDARD) {
					EditInspectorControl.paintEditPopups(p);
					p.flush();
				}
			%>
			<%@ include file="../../../../edit-header.html" %>
		<div id="container">
			<div id="wrap">
				<div id="eheader">
					<%
						north.paint(p, true);
						p.flush();
					%>&nbsp;
				</div> <!-- header -->
				<div id="content-wrap">
					<div id="econtent">
						<%
										view.paint(p, null, true);
										epilog.paint(p, true);
										p.close(false);
						%>
						<br />
						<%@ include file="../../../../edit-footer.html" %>
					</div> <!-- content -->
				</div> <!-- content-wrap -->
			</div> <!-- wrap -->
		</div> <!-- container -->
	</body>
</html>
<%
	}
	// EMBEDDED
	else if(view.getMode() == ViewMode.EMBEDDED) {
		view.paint(p, null, true);
		p.flush();
		p.close(false);
%>
<script language="javascript" type="text/javascript">
	//alert('postLoad edit');
</script>
<%
	}
%>
