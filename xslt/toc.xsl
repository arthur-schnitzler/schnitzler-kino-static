<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Inhaltsverzeichnis'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-header">
                                <h1>Inhaltsverzeichnis</h1>
                            </div>
                            <div class="card-body">
                                <table class="table table-striped display" id="tocTable"
                                    style="width:100%">
                                    <thead>
                                        <tr>
                                            <th scope="col">Datum</th>
                                            <th scope="col">Ort</th>
                                            <th scope="col">Filmtitel</th>
                                            <th scope="col">Kino</th>
                                            <th scope="col">Aufzeichnungen</th>
                                            <th scope="col">Wirt</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each
                                            select="collection('../data/editions')//tei:TEI">
                                            <xsl:variable name="full_path">
                                                <xsl:value-of select="document-uri(/)"/>
                                            </xsl:variable>
                                            <tr>
                                                <td>
                                                    <span hidden="hidden">
                                                        <xsl:value-of select="@xml:id"/>
                                                    </span>
                                                    <a>
                                                        <xsl:attribute name="href">                                                
                                                            <xsl:value-of select="replace(tokenize($full_path, '/')[last()], '.xml', '.html')"/>
                                                        </xsl:attribute>
                                                        <xsl:value-of
                                                            select="descendant::tei:titleStmt/tei:title[@when-iso][1]/@when-iso"
                                                        />
                                                    </a>
                                                </td>
                                                <td>
                                                    <xsl:value-of select=".//tei:place[@type='location']/tei:placeName/text()"/>
                                                </td>
                                                <td>
                                                    <xsl:value-of select="descendant::tei:text[1]/tei:body[1]/tei:div[4]/tei:table[1]/tei:row/tei:cell[@ana='Filmtitel']/text()"/>
                                                </td>
                                                <td><xsl:value-of select="descendant::tei:back/tei:listPlace/tei:place[@type='kino']/tei:placeName[1]/text()"/></td>
                                                <td><xsl:choose>
                                                    <xsl:when test="descendant::tei:text[1]/tei:body[1]/tei:div/@type='as' and descendant::tei:text[1]/tei:body[1]/tei:div/@type='ckp'">
                                                        <xsl:text>C.K. Pollaczek und A. Schnitzler</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="descendant::tei:text[1]/tei:body[1]/tei:div/@type='as'">
                                                        <xsl:text>Arthur Schnitzler</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="descendant::tei:text[1]/tei:body[1]/tei:div/@type='ckp'">
                                                        <xsl:text>Clara Katharina Pollaczek</xsl:text>
                                                    </xsl:when>
                                                </xsl:choose>
                                                    
                                                </td>
                                                <td><xsl:value-of select="descendant::tei:back/tei:listPlace/tei:place[@type='wirt']/tei:placeName[1]/text()"/></td>
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                    <script>
                        $(document).ready(function () {
                            createDataTable('tocTable')
                        });
                    </script>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:div//tei:head">
        <h2 id="{generate-id()}">
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    <xsl:template match="tei:p">
        <p id="{generate-id()}">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:list">
        <ul id="{generate-id()}">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:item">
        <li id="{generate-id()}">
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="starts-with(data(@target), 'http')">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
