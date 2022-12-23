<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:acdh="https://vocabs.acdh.oeaw.ac.at/schema#"
    version="2.0" exclude-result-prefixes="#all">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        <xsl:variable name="TopColId">
            <xsl:value-of select="data(.//acdh:TopCollection/@rdf:about)"/>
        </xsl:variable>
        <xsl:variable name="websiteDomain">
            <xsl:value-of select=".//acdh:TopCollection/acdh:hasUrl/text()"/>
        </xsl:variable>
        <xsl:variable name="constants">
            <xsl:for-each select=".//node()[parent::acdh:RepoObject]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:variable>
        <rdf:RDF>
            <xsl:for-each select=".//node()[parent::acdh:MetaAgents]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <acdh:TopCollection>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select=".//acdh:TopCollection/@rdf:about"/>
                </xsl:attribute>
                <xsl:for-each select=".//node()[parent::acdh:TopCollection]">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:copy-of select="$constants"/>
            </acdh:TopCollection>
            <acdh:Collection rdf:about="https://id.acdh.oeaw.ac.at/ckp/editions">
                <acdh:hasPid>https://hdl.handle.net/21.11115/0000-000F-79A1-3</acdh:hasPid>
                <acdh:isPartOf rdf:resource="https://id.acdh.oeaw.ac.at/ckp"/>
                <acdh:hasTitle xml:lang="de">Editionen</acdh:hasTitle>
                <acdh:hasDescription xml:lang="de">XML/TEI Dokumente</acdh:hasDescription>
                <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                <acdh:hasLifeCycleStatus rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelifecyclestatus/active"/>
                <xsl:copy-of select="$constants"/>
            </acdh:Collection>
            <xsl:for-each select="collection('../data/editions')//tei:TEI">
                <xsl:variable name="partOf">
                    <xsl:value-of select="concat($TopColId, '/editions')"/>
                </xsl:variable>
                <xsl:variable name="id">
                    <xsl:value-of select="concat($TopColId, '/', @xml:id)"/>
                </xsl:variable>
                <xsl:variable name="date">
                    <xsl:value-of select="data(.//tei:title[@when-iso][1]/@when-iso)"/>
                </xsl:variable>
                <acdh:Resource rdf:about="{$id}">
                    <acdh:hasUrl><xsl:value-of select="concat($websiteDomain, replace(@xml:id, '.xml', '.html'))"/></acdh:hasUrl>
                    <acdh:hasTitle xml:lang="de">CPK: <xsl:value-of select=".//tei:title[@level='a'][1]/text()"/>; Seite <xsl:value-of select="data(.//tei:seite/@id)"/></acdh:hasTitle>
                    <acdh:hasAccessRestriction rdf:resource="https://vocabs.acdh.oeaw.ac.at/archeaccessrestrictions/public"/>
                    <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei"/>
                    <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                    <xsl:choose>
                        <xsl:when test="string-length($date) eq 10">
                            <acdh:hasCoverageStartDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="$date"/></acdh:hasCoverageStartDate>
                        </xsl:when>
                    </xsl:choose>
                    
                    <acdh:isPartOf rdf:resource="{$partOf}"/>
                    <xsl:copy-of select="$constants"/>
                </acdh:Resource>
            </xsl:for-each>
        </rdf:RDF>
    </xsl:template>   
</xsl:stylesheet>
