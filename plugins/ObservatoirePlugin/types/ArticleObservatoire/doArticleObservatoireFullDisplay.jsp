<%@page import="fr.cg44.plugin.socle.SocleUtils"%><%
%><%@page import="fr.cg44.plugin.observatoire.ObservatoireUtils"%><%
%><%@ page contentType="text/html; charset=UTF-8" %><%
%><%@ taglib prefix="ds" tagdir="/WEB-INF/tags"%><%
%><%@ include file='/jcore/doInitPage.jspf' %><%
%><% ArticleObservatoire obj = (ArticleObservatoire)request.getAttribute(PortalManager.PORTAL_PUBLICATION); %><%
%><%@ include file='/front/doFullDisplay.jspf' %>
<%
boolean notEmptyLiensExternes = Util.notEmpty(obj.getLibellesLiensExternes()) && Util.notEmpty(obj.getLiensExternes());
boolean notEmptyLiensOpendata = Util.notEmpty(obj.getLibellesLiensOpendata()) && Util.notEmpty(obj.getLiensOpendata());
boolean hasAside = Util.notEmpty(obj.getIllustrationPrincipale()) || Util.notEmpty(obj.getTexteencart(userLang)) || Util.notEmpty(obj.getPortletEncartBas());
%>

<main id="content" role="main">

<jalios:include target="SOCLE_ALERTE"/>

    <article class="ds44-container-large">

        <ds:titleSimple pub="<%= obj %>" imagePath="" mobileImagePath="<%= obj.getImageMobile() %>" title="<%= obj.getTitle(userLang) %>"
            breadcrumb="true" legend="<%= obj.getLegende(userLang) %>" copyright="<%= obj.getCopyright(userLang) %>" backButton="true">
        </ds:titleSimple>
        
        <div class="ds44-inner-container ds44-xl-margin-tb">
            <div class='<%= hasAside ? "grid-12-small-1" : "ds44-grid12-offset-2" %>'>

                <%-- Colonne de gauche --%>
                
                <jalios:if predicate="<%= hasAside %>">
                    <div class='col-7'>
                </jalios:if>
                
                <jalios:if predicate='<%= Util.notEmpty(obj.getDescription(userLang)) %>'>
                    <div class="ds44-introduction">
                        <jalios:wysiwyg><%= obj.getDescription(userLang) %></jalios:wysiwyg>
                    </div>
                </jalios:if>
                
                <%-- Contenu --%>
                <jalios:if predicate='<%= Util.notEmpty(obj.getContenu(userLang)) %>'>
                    <jalios:wysiwyg><%= obj.getContenu(userLang) %></jalios:wysiwyg>            
                </jalios:if>                    
                
                <%-- On n'affiche pas certaines infos si on n'est pas dans les rubriques "cartes / stats / etudes" --%>
                <jalios:if predicate='<%= Util.notEmpty(ObservatoireUtils.getTypeArticleObservatoire(obj)) %>'>
                    <jalios:if predicate='<%= Util.notEmpty(obj.getSource()) %>'>
                        <p class="ds44-docListElem mts">
                            <i class="icon icon-user-group ds44-docListIco" aria-hidden="true"></i>
                            <strong><%= glp("jcmsplugin.socle.source") %> : </strong><%= obj.getSource() %>
                        </p>
                    </jalios:if>
                    <p class="ds44-docListElem mts">
					   <i class="icon icon-date ds44-docListIco" aria-hidden="true"></i>
					   <%=glp("jcmsplugin.socle.date-actualisation")%> <jalios:date date="<%= obj.getUdate() %>" format="dd/MM/yyyy"/>
				    </p>
                </jalios:if>
          
                <%-- Téléchargement --%>
                <jalios:if predicate="<%= Util.notEmpty(obj.getFichiers()) %>">
                    <section class="ds44-box ds44-theme ds44-mtb4">
                        <div class="ds44-innerBoxContainer">
                            <p role="heading" aria-level="2" class="ds44-box-heading"><%= glp("jcmsplugin.socle.fichepublication.telecharger") %></p>
                            <ul class="ds44-list">                                
                       <jalios:foreach name="itDoc" type="com.jalios.jcms.FileDocument" array="<%= obj.getFichiers() %>">
                           <jalios:if predicate='<%= itDoc != null && itDoc.canBeReadBy(loggedMember) %>'>
                              <% 
                               String title = HttpUtil.encodeForHTMLAttribute(itDoc.getTitle());
                               String fileType = FileDocument.getExtension(itDoc.getFilename()).toUpperCase();
                               String fileSize = Util.formatFileSize(itDoc.getSize());
                             %>
                           <li class="mts">
                             <jalios:include pub="<%= itDoc %>" usage="embed"/>
                           </li>
                           </jalios:if>
                             </jalios:foreach>
                            </ul>
                        </div>
                    </section>
                </jalios:if>
                
                <%-- Liens externes --%>
                <jalios:if predicate="<%= notEmptyLiensExternes %>">
                    <section class="ds44-box ds44-theme ds44-mtb4">
                        <div class="ds44-innerBoxContainer">
                            <div class="ds44-flex-container ds44-flex-valign-center">
                                <p role="heading" aria-level="2" class="ds44-box-heading"><%= glp("jcmsplugin.observatoire.liens-utiles") %></p>
                            </div>
                            <%
                            String[] liensExternesUrls = obj.getLiensExternes();
                            String[] liensExternesLibelles = obj.getLibellesLiensExternes();
                            %>
	                       <ul class="ds44-list">
	                           <jalios:foreach array="<%= liensExternesUrls %>" name="itUrl" type="String">
	                               <jalios:if predicate="<%= Util.notEmpty(itUrl) %>">
	                                   <%
	                                   // Récupération du titre
	                                   String linkTitle = "";
	                                   try {
	                                     linkTitle = liensExternesLibelles[itCounter - 1];                         
	                                     }
	                                   catch(IndexOutOfBoundsException e) {
	                                     linkTitle = itUrl;
	                                     }
	                                   %>
                                        <li class="mts">
                                            <div class="ds44-docListElem"><i class="icon icon-link ds44-docListIco" aria-hidden="true"></i>
                                                <a href="<%= itUrl %>" title='<%= glp("jcmsplugin.socle.lien.site.nouvelonglet", HttpUtil.encodeForHTMLAttribute(linkTitle)) %>' target="_blank"><%= linkTitle %></a>
                                            </div>
                                        </li>
	                               </jalios:if>
	                           </jalios:foreach>
                            </ul>
                        </div>
                    </section>
                </jalios:if>

				<%-- Liens opendata --%>
				<jalios:if predicate="<%=notEmptyLiensOpendata%>">
					<section class="ds44-box ds44-theme ds44-mtb4">
						<div class="ds44-innerBoxContainer">
							<div class="ds44-flex-container ds44-flex-valign-center">
								<p role="heading" aria-level="2" class="ds44-box-heading"><%=glp("jcmsplugin.observatoire.liens-opendata")%></p>
							</div>
                            <%
                            String[] liensOpendataUrls = obj.getLiensOpendata();
                            String[] liensOpendataLibelles = obj.getLibellesLiensOpendata();
							%>
							<ul class="ds44-list">
								<jalios:foreach array="<%=liensOpendataUrls%>" name="itUrl" type="String">
									<jalios:if predicate="<%=Util.notEmpty(itUrl)%>">
                                        <%
                                        // Récupération du titre
								        String linkTitle = "";
								        try {
								          linkTitle = liensOpendataLibelles[itCounter - 1];
								        } catch (IndexOutOfBoundsException e) {
								          linkTitle = itUrl;
								        }
										%>
										<li class="mts">
                                            <div class="ds44-docListElem"><i class="icon icon-data ds44-docListIco" aria-hidden="true"></i>
                                                <a href="<%=itUrl%>"
                                                   title='<%=glp("jcmsplugin.socle.opendata.link.title", HttpUtil.encodeForHTMLAttribute(linkTitle))%>'
                                                   target="_blank"><%=glp("jcmsplugin.socle.opendata.link.label", linkTitle)%></a>
                                            </div>
										</li>
									</jalios:if>
								</jalios:foreach>
							</ul>
						</div>
					</section>
				</jalios:if>

				<%-- Mots clés --%>
                <%
                  Publication portletSearchPub = channel.getPublication(channel.getProperty("jcmsplugin.socle.recherche.portletsearch.id"));
                %>
                <jalios:if predicate='<%=Util.notEmpty(obj.getMotsCles(loggedMember)) && Util.notEmpty(portletSearchPub) && portletSearchPub instanceof PortletRechercheFacettes%>'>
                    <%
                    // Lien vers la recherche : Récupère les information de la portlet de recherche principale et de sa facette mot-clés
                    PortletRechercheFacettes portletSearch = (PortletRechercheFacettes) channel.getPublication(channel.getProperty("jcmsplugin.socle.recherche.portletsearch.id"));
                    // N'affiche pas les mot-clé si la facette mot-clé n'est pas présente en 3 eme position
                    if(portletSearch.getFacettesPrincipales().length < 3 || !(portletSearch.getFacettesPrincipales()[2] instanceof PortletFacetteCategorie)){
                      break;
                    }
                    PortletFacetteCategorie portletFacetteMotCle = (PortletFacetteCategorie) portletSearch.getFacettesPrincipales()[2];                           
                    String portetSearchLink = channel.getPublication("$jcmsplugin.socle.recherche.facettes.portal").getDisplayUrl(userLocale) + "?boxId=" + portletSearch.getId();                       
                    %>
         
                    <section class="ds44-mtb4">
                        <h3><%= glp("jcmsplugin.socle.motscles") %></h3>
                        <ul class="ds44-list ds44-list--tag ds44--m-padding">	                          
					        <jalios:foreach collection="<%= obj.getMotsCles(loggedMember) %>" type="Category" name="itCategory">
					            <%
					            // Génère le lien vers la recherche avec le mot-clé de sélectionné
					            String itSearchLink = portetSearchLink + "&cids" + glp("jcmsplugin.socle.facette.form-element") + "-" + portletSearch.getId() + portletFacetteMotCle.getId() + "[value]=" + itCategory.getId() + "&cids" + glp("jcmsplugin.socle.facette.form-element") + "-" + portletSearch.getId() + portletFacetteMotCle.getId() + "[text]=" + itCategory.getName(userLang);
					            %>
	                            <li><a href="<%= itSearchLink %>" class="ds44-btnStd ds44-btn--invert ds44-btnStd--tag" title='<%= glp("jcmsplugin.observatoire.motcle.title", itCategory)%>'><span class="ds44-btnInnerText"><%=itCategory%></span></a></li>
					        </jalios:foreach>
                        </ul>
                    </section>
                </jalios:if>                    
            
                <%-- Voir aussi --%>
                <jalios:if predicate='<%= Util.notEmpty(obj.getVoirAussi()) %>'>
                    <section class="ds44-mtb4 ds44-innerBoxContainer ds44-borderContainer">
                        <h2 class="h2-like"><%= glp("jcmsplugin.socle.voiraussi") %></h2>
                        <ul class="ds44-list">
				            <jalios:foreach name="itData" type="com.jalios.jcms.Content" array="<%=obj.getVoirAussi()%>">
                                <jalios:if predicate='<%=itData != null && itData.canBeReadBy(loggedMember)%>'>
                                    <%
                                    String typeArticle = ObservatoireUtils.getTypeArticleObservatoire(itData);
                                    String icone = "";
                                    if(Util.notEmpty(typeArticle)) {
                                      icone = glp("jcmsplugin.observatoire."+typeArticle+".icone");
                                    }
                                    %>
                                    <li class="mts">
                                        <p class="ds44-docListElem">
                                            <i class="icon <%= icone %> ds44-docListIco" aria-hidden="true"></i>
                                            <jalios:link data="<%= itData %>"/>
                                        </p>
                                    </li>
					           </jalios:if>
                            </jalios:foreach>
                        </ul>
                    </section>	                
                </jalios:if>

                
                <!-- Colonne de droite -->
                <jalios:if predicate="<%= hasAside %>">
                    </div> 
                    <div class="col-1 grid-offset ds44-hide-tiny-to-medium"></div>
                
	                <aside class="col-4">
	                
	                    <jalios:if predicate='<%= Util.notEmpty(obj.getIllustrationPrincipale()) %>'>
	                        <ds:figurePicture imgCss="ds44-w100" pictureCss="ds44-legendeContainer" 
	                            format="custom" width="370" height="500" image="<%= obj.getIllustrationPrincipale() %>" imageMobile="<%= obj.getImageMobile() %>"
	                            alt="<%= obj.getTexteAlternatif(userLang) %>"
	                            copyright="<%= obj.getCopyright(userLang) %>" legend="<%= obj.getLegende(userLang) %>"/>
	                    </jalios:if>
	                    
	                    <jalios:if predicate='<%= Util.notEmpty(obj.getTexteencart(userLang)) %>'>
			                <section class="ds44-box ds44-bgGray mtm">
	                            <div class="ds44-innerBoxContainer">
	                                <jalios:wysiwyg><%= obj.getTexteencart(userLang) %></jalios:wysiwyg>
	                            </div>
	                        </section> 
	                    </jalios:if>
	            
			            <jalios:if predicate='<%= Util.notEmpty(obj.getPortletEncartBas()) %>'>
			                <jalios:foreach name="itPortletEncartBas" type="PortalElement" array="<%= obj.getPortletEncartBas() %>">
	                            <jalios:include pub="<%= itPortletEncartBas %>"/>
	                        </jalios:foreach> 
			            </jalios:if>                    
	                    
	                </aside>
	                
                </jalios:if>
            </div>
        </div>
        
    </article>
    
    <%-- Partagez cette page --%>
    <%@ include file="/plugins/SoclePlugin/jsp/portal/socialNetworksShare.jspf" %>
    
    <%-- Page utile --%>
    <jsp:include page="/plugins/SoclePlugin/types/PageUtileForm/editFormPageUtileForm.jsp"/>
    
</main>
