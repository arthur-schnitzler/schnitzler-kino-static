<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/osd-container.xsl"/>
    <xsl:import href="./partials/tei-facsimile.xsl"/>
    <xsl:import href="./partials/person.xsl"/>
    <xsl:import href="./partials/place.xsl"/>
    <xsl:import href="./partials/org.xsl"/>

    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
 
    

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="descendant::tei:titleStmt/tei:title[@when-iso][1]/text()"/>
        </xsl:variable>
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <html>
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
            </xsl:call-template>
            
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    
                    <div class="container-fluid">                        
                        <div class="card" data-index="true">
                            <div class="card-header">
                                <div class="row">
                                    <div class="col-md-2">
                                        <xsl:if test="ends-with($prev,'.html')">
                                            <h1>
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$prev"/>
                                                    </xsl:attribute>
                                                    <i class="fas fa-chevron-left" title="prev"/>
                                                </a>
                                            </h1>
                                        </xsl:if>
                                    </div>
                                    <div class="col-md-8">
                                        <h1 align="center">
                                            <xsl:value-of select="$doc_title"/>
                                        </h1>
                                        <h3 align="center">
                                            <a href="{$teiSource}">
                                                <i class="fas fa-download" title="show TEI source"/>
                                            </a>
                                        </h3>
                                    </div>
                                    <div class="col-md-2" style="text-align:right">
                                        <xsl:if test="ends-with($next, '.html')">
                                            <h1>
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$next"/>
                                                    </xsl:attribute>
                                                    <i class="fas fa-chevron-right" title="next"/>
                                                </a>
                                            </h1>
                                        </xsl:if>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-5" style="background: #f1f1f1">
                                        <xsl:choose>
                                            <xsl:when test="descendant::tei:div[@type='as']">
                                                <h2><a href="{descendant::tei:div[@type='as']/@source}" target="_blank" style="color:#037A33">Schnitzler, Tagebuch:</a></h2>
                                                <xsl:apply-templates select=".//tei:div[@type='as']"/>
                                                <p/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <h2><a href="{concat('https://schnitzler-tagebuch.acdh.oeaw.ac.at/entry__', ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title/@when-iso, '.html')}" target="_blank">Schnitzler, Tagebuch:</a></h2>
                                                <p><i>[kein diesbez??glicher Eintrag]</i></p>
                                                <p/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </div>
                                    <div class="col-md-2" style="background: white"/>
                                    <div class="col-md-5" style="background: #f1f1f1">
                                        <xsl:choose>
                                            <xsl:when test="descendant::tei:div[@type='ckp']">
                                                <h2><a href="{descendant::tei:div[@type='ckp']/@source}" target="_blank" style="color:#1e81b0">Pollaczek, Tagebuch:</a></h2>
                                                <xsl:apply-templates select="descendant::tei:div[@type='ckp']"/>
                                                <p/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <h2>Pollaczek, Tagebuch:</h2>
                                                <p><i>[kein diesbez??glicher Eintrag]</i></p>
                                                <p/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </div>
                                </div>
                                
                                
                            </div>
                            <div class="card-footer">
                                <xsl:if test="descendant::tei:note[@type='kommentar']">
                                <ul>
                                    <xsl:for-each select="descendant::tei:note[@type='kommentar']/tei:p">
                                            <li><xsl:apply-templates/></li>
                                    </xsl:for-each>
                                </ul>
                                </xsl:if>
                                <xsl:if test="descendant::tei:div[@type='film']">
                                    <dl>
                                    <xsl:for-each select="descendant::tei:cell[@role='data']">
                                        <xsl:element name="dt">
                                            <xsl:value-of select="@ana"/><xsl:text> </xsl:text>
                                        </xsl:element>
                                        <xsl:element name="dd">
                                            <xsl:choose>
                                                <xsl:when test="@ana='Darsteller_innen'">
                                                    <ul>
                                                        <xsl:for-each select="tokenize(., ',')">
                                                            <li><xsl:value-of select="normalize-space(.)"/></li>
                                                        </xsl:for-each>
                                                    </ul>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:apply-templates/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:for-each>
                                    </dl>
                                </xsl:if>
                            </div>
                        </div>                       
                    </div>
                    <xsl:for-each select=".//tei:back//tei:org[@xml:id]">
                        
                        <div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
                            <xsl:attribute name="id">
                                <xsl:value-of select="./@xml:id"/>
                            </xsl:attribute>
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">
                                            <xsl:value-of select=".//tei:orgName[1]/text()"/>
                                        </h5>
                                        
                                    </div>
                                    <div class="modal-body">
                                        <xsl:call-template name="org_detail">
                                            <xsl:with-param name="showNumberOfMentions" select="5"/>
                                        </xsl:call-template>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Schlie??en</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </xsl:for-each>
                    <xsl:for-each select=".//tei:back//tei:person[@xml:id]">
                        <xsl:variable name="xmlId">
                            <xsl:value-of select="data(./@xml:id)"/>
                        </xsl:variable>
                        
                        <div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true" id="{$xmlId}">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">
                                            <xsl:value-of select="normalize-space(string-join(.//tei:persName[1]//text()))"/>
                                            <xsl:text> </xsl:text>
                                            <a href="{concat($xmlId, '.html')}">
                                                <i class="fas fa-external-link-alt"></i>
                                            </a>
                                        </h5>
                                        
                                    </div>
                                    <div class="modal-body">
                                        <xsl:call-template name="person_detail">
                                            <xsl:with-param name="showNumberOfMentions" select="5"/>
                                        </xsl:call-template>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Schlie??en</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </xsl:for-each>
                    <xsl:for-each select=".//tei:back//tei:place[@xml:id]">
                        <xsl:variable name="xmlId">
                            <xsl:value-of select="data(./@xml:id)"/>
                        </xsl:variable>
                        
                        <div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true" id="{$xmlId}">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">
                                            <xsl:value-of select="normalize-space(string-join(.//tei:placeName[1]/text()))"/>
                                            <xsl:text> </xsl:text>
                                            <a href="{concat($xmlId, '.html')}">
                                                <i class="fas fa-external-link-alt"></i>
                                            </a>
                                        </h5>
                                    </div>
                                    <div class="modal-body">
                                        <xsl:call-template name="place_detail">
                                            <xsl:with-param name="showNumberOfMentions" select="5"/>
                                        </xsl:call-template>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Schlie??en</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </xsl:for-each>
                    <xsl:call-template name="html_footer"/>
                </div>
                    
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:p">
        <p id="{local:makeId(.)}">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <xsl:template match="tei:div">
        <div id="{local:makeId(.)}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>  
    <xsl:template match="tei:bibl[starts-with(@facs, 'http')]">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:value-of select="@facs"/>
            </xsl:attribute>
            <xsl:attribute name="target">
                <xsl:text>_blank</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    
    </xsl:template>
    
    <xsl:template match="tei:bibl[not(starts-with(@facs, 'http'))]">
            <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:bibl/tei:author">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>
  
  
  
    <xsl:template match="tei:bibl/tei:title">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:bibl/tei:biblScope">
        <xsl:choose>
            <xsl:when test="@unit='page'">
                <xsl:text>, S. </xsl:text>
            </xsl:when>
            <xsl:when test="@unit='volume'">
                <xsl:text>, Bd. </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:bibl/tei:date">
        <xsl:text>, </xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    
    
    <xsl:template match="tei:bibl[not(starts-with(@facs, 'http'))]">
        
            <xsl:apply-templates/>
        
        
    </xsl:template>
    
    

</xsl:stylesheet>