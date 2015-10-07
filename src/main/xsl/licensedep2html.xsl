<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <!--
      Purpose of this stylesheet:
      Transform the xml output of the License Maven Plugin's 3rd parties report, generated w/
      'license:download-licenses'

      (for further information see: http://www.mojohaus.org/license-maven-plugin/) to HTML.

      Version:  0.01

      Date:     07.10.2014

      Author: Karsten Gresch

      Last edited by: Karsten Gresch

      === Version History ===
      0.01: Initial version /2015-10-07 Karsten Gresch
-->


  <xsl:output method="xml" indent="yes" encoding="UTF-8" media-type="text/xml"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="licenseSummary">
    <html>
      <head>
        <title>License Report for 3rd Part Dependencies</title>
        <style>
          table {
            border-collapse: collapse;
          }

          table, th, td {
            border: 1px solid black;
          }

          /* TODO Selector for sub-table*/

        </style>
      </head>
      <body>
        <h2>License Report for 3rd Part Dependencies</h2>
        <xsl:apply-templates select="/licenseSummary/dependencies"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="dependencies">
    <table>

        <tr>
          <th>Maven-groupId</th>
          <th>Maven-artifactId</th>
          <th>Maven-version</th>
          <th><xsl:attribute name="colspan">4</xsl:attribute>License Information</th>
        </tr>

      <xsl:apply-templates select="dependency"/>

    </table>
  </xsl:template>

  <xsl:template match="dependency">
    
      <!-- <xsl:variable name="number_licenses" select="if ( count(./licenses/license) = 0 ) then 2 else count(./licenses/license) + 1" />-->

    <xsl:variable name="number_licenses">

        <xsl:choose>
          <xsl:when test="count(./licenses/license) = 0">2</xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="count(./licenses/license) + 1" />
          </xsl:otherwise>
        </xsl:choose>

        </xsl:variable>




  <tr>
    <td><xsl:attribute name="rowspan"><xsl:copy-of select="$number_licenses"/></xsl:attribute><xsl:copy-of select="groupId" /></td>
    <td><xsl:attribute name="rowspan"><xsl:copy-of select="$number_licenses"/></xsl:attribute><xsl:copy-of select="artifactId" /></td>
    <td><xsl:attribute name="rowspan"><xsl:copy-of select="$number_licenses"/></xsl:attribute><xsl:copy-of select="version" /></td>
   <xsl:apply-templates select="licenses"/>
  </tr>

  </xsl:template>

  <xsl:template match="licenses">
          <td>License Name</td>
          <td>License URL</td>
          <td>License Distribution</td>
          <td>License Comment</td>
          <xsl:apply-templates select="license"/>

  </xsl:template>

  <xsl:template match="license">
    <tr>

      <xsl:choose>

        <xsl:when test="name[not(normalize-space())]">
          <xsl:apply-templates select="name" mode="empty"/>
        </xsl:when>
        <xsl:when test="string(name)">
          <xsl:apply-templates select="name" mode="placeholder"/>
        </xsl:when>
      </xsl:choose>

      <xsl:choose>

        <xsl:when test="url[not(*)][not(normalize-space())]">
          <xsl:apply-templates select="url" mode="empty"/>
        </xsl:when>
        <xsl:when test="string(url)">
          <xsl:apply-templates select="url" mode="placeholder"/>
        </xsl:when>
      </xsl:choose>


      <xsl:choose>

        <xsl:when test="url[not(*)][not(normalize-space())]">
          <xsl:apply-templates select="distribution" mode="empty"/>
        </xsl:when>
        <xsl:when test="string(distribution)">
          <xsl:apply-templates select="distribution" mode="placeholder"/>
        </xsl:when>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="url[not(*)][not(normalize-space())]">
          <xsl:apply-templates select="comment" mode="empty"/>
        </xsl:when>
        <xsl:when test="string(comment)">
          <xsl:apply-templates select="comment" mode="placeholder"/>
        </xsl:when>

      </xsl:choose>








      <!-- <td><a><xsl:attribute name="href"><xsl:copy-of select="url" /></xsl:attribute><xsl:copy-of select="url" /></a></td>
      <td><xsl:copy-of select="url" /></td>
      <td><xsl:copy-of select="distribution" /></td>
      <td><xsl:copy-of select="comment" /></td>
      <xsl:apply-templates select="url" mode="placeholder"/>
      <xsl:apply-templates select="distribution" mode="placeholder"/>
      <xsl:apply-templates select="comment" mode="placeholder"/>-->
    </tr>
  </xsl:template>

  <xsl:template match="name | url | distribution | comment" mode="placeholder">
    <placeholder>PL </placeholder>
      <td><xsl:copy-of select="." /></td>
  </xsl:template>


  <xsl:template match="name | url | distribution | comment" mode="empty">
        <empty>EM </empty>
        <td><xsl:text>-</xsl:text></td>
  </xsl:template>


</xsl:stylesheet>