<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="b4soc" uri="http://www.jahia.org/tags/b4sociallogin" %>

<%--@elvariable id="currentUser" type="org.jahia.services.usermanager.JahiaUser"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<c:set var="site" value="${renderContext.site.title}"/>
<c:set var="redirect" value="${currentResource.moduleParams.redirect}"/>
<c:set var="failureRedirect" value="${currentResource.moduleParams.failureRedirect}"/>
<style>
    .social-buttons a {
        margin: 0 0.5rem 1rem;
    }
</style>

<c:set var="sitekey" value="${renderContext.site.siteKey}"/>

<c:set var="loginMenuULClass" value="${currentNode.properties.loginMenuULClass.string}"/>
<c:if test="${empty loginMenuULClass}">
    <c:set var="loginMenuULClass" value="navbar-nav d-none d-md-flex"/>
</c:if>
<c:choose>
    <c:when test="${renderContext.loggedIn}">
        <ul class="${loginMenuULClass}">
            <li class="nav-item dropdown">

                <a class="nav-item nav-link dropdown-toggle mr-md-2" href="#" id="${currentNode.identifier}"
                   data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">

                        ${currentUser.name}
                </a>
                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="${currentNode.identifier}">
                    <c:if test="${!renderContext.settings.distantPublicationServerMode and renderContext.mainResource.node.properties['j:originWS'].string ne 'live' and not jcr:isNodeType(renderContext.mainResource.node.resolveSite, 'jmix:remotelyPublished')}">
                        <c:if test="${! renderContext.liveMode}">
                            <a href="<c:url value='${url.live}'/>" class="dropdown-item">
                                <fmt:message key="bootstrap4mix_customBaseNavbar.label.live"/>
                            </a>
                        </c:if>
                        <c:if test="${! renderContext.previewMode && jcr:hasPermission(renderContext.mainResource.node, 'jContentAccess')}">
                            <a href="<c:url value='${url.preview}'/>" class="dropdown-item">
                                <fmt:message key="bootstrap4mix_customBaseNavbar.label.preview"/>
                            </a>
                        </c:if>
                        <c:if test="${! renderContext.editMode && jcr:hasPermission(renderContext.mainResource.node, 'jContentAccess')}">
                            <a href="<c:url value='${url.edit}'/>" class="dropdown-item">
                                <fmt:message key="bootstrap4mix_customBaseNavbar.label.edit"/>
                            </a>
                        </c:if>
                        <c:if test="${! renderContext.editMode && !jcr:hasPermission(renderContext.mainResource.node, 'jContentAccess') && jcr:hasPermission(renderContext.mainResource.node, 'contributeModeAccess')}">
                            <a href="<c:url value='${url.contribute}'/>" class="dropdown-item">
                                <fmt:message key="bootstrap4mix_customBaseNavbar.label.contribute"/>
                            </a>
                        </c:if>
                    </c:if>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="${url.logout}" class="logout"><fmt:message
                            key="bootstrap4mix_customBaseNavbar.label.logout"/></a>
                </div>
            </li>
        </ul>
    </c:when>
    <c:otherwise>
        <ul class="${loginMenuULClass}">
            <li class="nav-item">
                <a class="nav-link p-2 login" href="${url.login}" data-toggle="modal" data-target="#loginModal">
                    <fmt:message key="bootstrap4mix_customBaseNavbar.label.login"/>
                </a>
            </li>
        </ul>
    </c:otherwise>
</c:choose>


<div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
     aria-hidden="true" data-backdrop="false">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header border-bottom-0">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <c:set var="showModal" value="${not empty param['loginError'] ? 'true' : 'false'}"/>
                <utility:logger level="info" value="loginError : ${param['loginError']}"/>
                <c:if test="${not empty param['loginError']}">
                    <div class="alert text-danger">
                        <c:choose>
                            <c:when test="${param['loginError'] == 'account_locked'}">
                                <fmt:message key="login-form.message.accountLocked"/>
                            </c:when>
                            <c:when test="${param['loginError'] == 'logged_in_users_limit_reached'}">
                                <fmt:message key="login-form.message.userLimitReached"/>
                            </c:when>
                            <c:otherwise>
                                <fmt:message key="login-form.message.incorrectLogin"/>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
                <div class="form-title text-center">
                    <h4>Login</h4>
                </div>
                <div class="d-flex flex-column text-center">
                    <form method="post" name="loginForm" action="${url.login}">
                        <input type="hidden" name="site" value="${site}">
                        <input type="hidden" name="redirect" value="${redirect}">
                        <input type="hidden" name="failureRedirect" value="${failureRedirect}">
                        <div class="form-group">
                            <label for="username" class="text-primary text-uppercase"><fmt:message
                                    key="login-form.label.username"/></label>
                            <input type="text" class="form-control" name="username" id="username"
                                   placeholder="<fmt:message key="login-form.placeholder.username"/>">
                        </div>

                        <div class="form-group">
                            <label for="password" class="text-primary text-uppercase"><fmt:message
                                    key="login-form.label.password"/></label>
                            <input type="password" class="form-control" name="password" id="password"
                                   placeholder="<fmt:message key="login-form.placeholder.password"/>">
                        </div>

                        <button type="submit" class="btn btn-primary text-uppercase"><fmt:message
                                key="login-form.btn.login"/></button>
                    </form>
                    <hr class="mt-3 mb-3"/>
                    <div class="text-center text-muted delimiter">or use a social network</div>
                    <div class="d-flex justify-content-center social-buttons">
                        <c:if test="${b4soc:validateSocialNetwork('LinkedInApi20',sitekey)}">
                            <template:include view="hidden.sociallogin.linkedInButton"/>
                        </c:if>
                        <c:if test="${b4soc:validateSocialNetwork('FacebookApi',sitekey)}">
                            <template:include view="hidden.sociallogin.facebookButton"/>
                        </c:if>
                        <c:if test="${b4soc:validateSocialNetwork('GitHubApi',sitekey)}">
                            <template:include view="hidden.sociallogin.githubButton"/>
                        </c:if>
                        <c:if test="${b4soc:validateSocialNetwork('GoogleApi20',sitekey)}">
                            <template:include view="hidden.sociallogin.googleButton"/>
                        </c:if>

                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

