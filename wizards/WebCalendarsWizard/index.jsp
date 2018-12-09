<%@page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%
/*
 * ====================================================================
 * Project:     openCRX/Core, http://www.opencrx.org/
 * Description: Redirect to Web Calendars
 * Owner:       CRIXP Corp., Switzerland, http://www.crixp.com
 * ====================================================================
 *
 * This software is published under the BSD license
 * as listed below.
 *
 * Copyright (c) 2014 CRIXP Corp., Switzerland
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * * Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in
 * the documentation and/or other materials provided with the
 * distribution.
 *
 * * Neither the name of CRIXP Corp. nor the names of the contributors
 * to openCRX may be used to endorse or promote products derived
 * from this software without specific prior written permission
 *
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
 * This product includes software developed by contributors to
 * openMDX (http://www.openmdx.org/)
 */
%><%@ page session="true" import="
		   java.util.*,
		   java.io.*,
		   java.text.*,
		   org.openmdx.kernel.id.cci.*,
		   org.openmdx.base.accessor.jmi.cci.*,
		   org.openmdx.base.exception.*,
		   org.openmdx.portal.servlet.*,
		   org.openmdx.portal.servlet.attribute.*,
		   org.openmdx.portal.servlet.component.*,
		   org.openmdx.portal.servlet.control.*,
		   org.openmdx.portal.servlet.action.*,
		   org.openmdx.portal.servlet.wizards.*,
		   org.openmdx.base.naming.*,
		   org.openmdx.kernel.log.*,
		   org.openmdx.kernel.id.*
		   " %>
<%!

	public static class WebCalendarsWizardController extends org.openmdx.portal.servlet.AbstractWizardController {
	
		public List<org.opencrx.kernel.home1.jmi1.CalendarProfile> getCalendarProfiles(
		) throws ServiceException {
			javax.jdo.PersistenceManager pm = this.getPm();
			RefObject_1_0 refObj = this.getObject();
			if(refObj instanceof org.opencrx.kernel.home1.jmi1.UserHome) {
				org.opencrx.kernel.home1.jmi1.UserHome userHome = (org.opencrx.kernel.home1.jmi1.UserHome)refObj;
				org.opencrx.kernel.home1.cci2.CalendarProfileQuery query = (org.opencrx.kernel.home1.cci2.CalendarProfileQuery)pm.newQuery(org.opencrx.kernel.home1.jmi1.CalendarProfile.class);
				query.thereExistsFeed().thereExistsIsActive().isTrue();
				query.orderByName().ascending();
				return userHome.getSyncProfile(query);
			}
			return Collections.emptyList();
		}
		
		public void doCancel(
		) throws ServiceException {
			this.setExitAction(
				new ObjectReference(this.getObject(), this.getApp()).getSelectObjectAction()
			);
		}

		public void doRefresh(
		) throws ServiceException {
	   		
		}
	   	
		public String getRedirectUrl(
			org.opencrx.kernel.home1.jmi1.CalendarProfile calendarProfile
		) {
			ApplicationContext app = this.getApp();
			String providerName = this.getProviderName();
			String segmentName = this.getSegmentName();
			return
				this.getRequest().getContextPath().replace("-core-", "-calendar-") + 
				"/?cal=" + providerName + "/" + segmentName + "/" + app.getLoginPrincipal() + "/" + java.net.URLEncoder.encode(calendarProfile.getName()).replace("+", "%20");
		}

	}

%>
<%
	String FORM_NAME = "WebCalendarsForm";
	WebCalendarsWizardController wc = new WebCalendarsWizardController();
%>
<t:wizardHandleCommand controller='<%= wc %>' defaultCommand='Refresh' />
<%
	if(response.getStatus() != HttpServletResponse.SC_OK) {
		wc.close();		
		return;
	}
	ApplicationContext app = wc.getApp();
	javax.jdo.PersistenceManager pm = wc.getPm();
	RefObject_1_0 obj = wc.getObject();
%>
<div class="OperationDialogTitle"><%= wc.getToolTip() %></div>
<form id="<%= FORM_NAME %>" name="<%= FORM_NAME %>" accept-charset="UTF-8" method="POST" action="<%= wc.getServletPath() %>">
	<%
		if(wc.getErrorMessage() != null && !wc.getErrorMessage().isEmpty()) {
	%>
	<div class="alert alert-danger" role="alert">
		<table>
			<tr>
				<td style="vertical-align:top;padding:10px;"><span class="glyphicon glyphicon-exclamation-sign"></span></td>
				<td><%= wc.getErrorMessage() %></td>
			</tr>
		</table>
	</div>
	<%
		}
	%>
	<input type="hidden" name="<%= Action.PARAMETER_REQUEST_ID %>" value="<%= wc.getRequestId() %>" />
	<input type="hidden" name="<%= Action.PARAMETER_OBJECTXRI %>" value="<%= wc.getObjectIdentity().toXRI() %>" />
	<input type="hidden" id="Command" name="Command" value="" />
	<table class="tableLayout">
		<tr>
			<td class="cellObject">
				<div class="panel" id="panel<%= FORM_NAME %>" style="display:block;overflow:visible;">
					<ul class="nav nav-pills">
						<%
												for(org.opencrx.kernel.home1.jmi1.CalendarProfile calendarProfile: wc.getCalendarProfiles()) {
						%>
						<li><a target="_blank" href="..<%= wc.getRedirectUrl(calendarProfile) %>"><%= calendarProfile.getName() %></a></li>
							<%
													}
							%>
					</ul>
				</div>
				<div id="WaitIndicator" style="float:left;width:50px;height:24px;" class="wait">&nbsp;</div>
				<div id="SubmitArea" style="float:left;display:none;">
					<input type="submit" name="Cancel" class="<%= CssClass.btn.toString() %> <%= CssClass.btnDefault.toString() %>" tabindex="9020" value="<%= app.getTexts().getCancelTitle() %>" onclick="javascript:$('WaitIndicator').style.display = 'block';$('SubmitArea').style.display = 'none'; $('Command').value = this.name;" />
				</div>
			</td>
		</tr>
	</table>
</form>
<br />
<script type="text/javascript">
	Event.observe('<%= FORM_NAME %>', 'submit', function (event) {
		$('<%= FORM_NAME %>').request({
			onFailure: function () { },
			onSuccess: function (t) {
				$('UserDialog').update(t.responseText);
			}
		});
		Event.stop(event);
	});
	$('WaitIndicator').style.display = 'none';
	$('SubmitArea').style.display = 'block';
</script>
<t:wizardClose controller="<%= wc %>" />
