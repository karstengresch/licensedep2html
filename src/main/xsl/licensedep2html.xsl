<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <!--
      Purpose of this stylesheet:
      Transform the xml output of the License Maven Plugin's 3rd parties report, generated w/
      'license:download-licenses'

      (for further information see: http://www.mojohaus.org/license-maven-plugin/) to HTML.

      Version:  0.02

      Date:     08.10.2014

      Author: Karsten Gresch

      Last edited by: Karsten Gresch

      === Version History ===
      0.01: Initial version /2015-10-07 Karsten Gresch
      0.02: Fixed table to make it easier for importing into Libre Office /2015-10-08 Karsten Gresch
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
          <td><em>Name</em></td>
          <td><em>URL</em></td>
          <td><em>Distribution</em></td>
          <td><em>Comment</em></td>
    <xsl:choose>
          <xsl:when test="license">
            <xsl:for-each select="license">
              <xsl:apply-templates select="current()"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <tr>
            <td><xsl:text>-</xsl:text></td>
            <td><xsl:text>-</xsl:text></td>
            <td><xsl:text>-</xsl:text></td>
            <td><xsl:text>-</xsl:text></td>
            </tr>
          </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template match="license">
    <tr>

      <xsl:choose>
        <xsl:when test="name">
          <xsl:apply-templates select="name" mode="placeholder"/>
        </xsl:when>
        <xsl:otherwise>
          <td><xsl:text>-</xsl:text></td>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="url">
          <xsl:apply-templates select="url" mode="placeholder"/>
        </xsl:when>
        <xsl:otherwise>
          <td><xsl:text>-</xsl:text></td>
        </xsl:otherwise>
      </xsl:choose>


      <xsl:choose>
        <xsl:when test="distribution">
          <xsl:apply-templates select="distribution" mode="placeholder"/>
        </xsl:when>
        <xsl:otherwise>
          <td><xsl:text>-</xsl:text></td>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="comments">
          <xsl:apply-templates select="comments" mode="placeholder"/>
        </xsl:when>
        <xsl:otherwise>
          <td><xsl:text>-</xsl:text></td>
        </xsl:otherwise>

      </xsl:choose>
    </tr>
  </xsl:template>

  <xsl:template match="name | url | distribution | comments" mode="placeholder">
      <td><xsl:copy-of select="." /></td>
  </xsl:template>


</xsl:stylesheet>