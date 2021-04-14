object dmThumbnailResources: TdmThumbnailResources
  OldCreateOrder = False
  Height = 260
  Width = 341
  object ThumbTemplate: TXMLDocument
    NodeIndentStr = #9
    Options = [doNodeAutoIndent]
    XML.Strings = (
      '<?xml version="1.0"?>'
      
        '<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/' +
        'XSL/Transform" xmlns:b="http://www.fatturapa.gov.it/sdi/fatturap' +
        'a/v1.1" xmlns:c="http://www.fatturapa.gov.it/sdi/fatturapa/v1.0"' +
        ' xmlns:a="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fattu' +
        're/v1.2" xmlns:d="http://ivaservizi.agenziaentrate.gov.it/docs/x' +
        'sd/fatture/v1.0">'
      #9'<xsl:output method="html"/>'
      
        #9'<xsl:decimal-format name="euro" decimal-separator="," grouping-' +
        'separator="."/>'
      #9'<xsl:template name="FormatDateIta">'
      #9#9'<xsl:param name="DateTime"/>'
      #9#9'<xsl:variable name="year" select="substring($DateTime,1,4)"/>'
      #9#9'<xsl:variable name="month" select="substring($DateTime,6,2)"/>'
      #9#9'<xsl:variable name="day" select="substring($DateTime,9,2)"/>'
      #9#9'<xsl:value-of select="$day"/>'
      #9#9'<xsl:value-of select="'#39'/'#39'"/>'
      #9#9'<xsl:value-of select="$month"/>'
      #9#9'<xsl:value-of select="'#39'/'#39'"/>'
      #9#9'<xsl:value-of select="$year"/>'
      #9'</xsl:template>'
      #9'<xsl:template match="/">'
      
        #9#9'<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64"' +
        ' version="1">'
      
        #9#9#9'<path style="opacity:0.2" d="m 14.5,7.9999999 c -1.385,0 -2.5' +
        ',1.115 -2.5,2.5000001 v 45 c 0,1.385 1.115,2.5 2.5,2.5 h 35 C 50' +
        '.885,58 52,56.885 52,55.5 V 23 L 38.25,21.75 37,7.9999999 Z"/>'
      
        #9#9#9'<path fill="#e4e4e4" d="m14.5 7c-1.385 0-2.5 1.115-2.5 2.5v45' +
        'c0 1.385 1.115 2.5 2.5 2.5h35c1.385 0 2.5-1.115 2.5-2.5v-32.5l-1' +
        '3.75-1.25-1.25-13.75z"/>'
      
        #9#9#9'<path style="opacity:0.2" d="M 37,7.9999999 V 20.5 c 0,1.3808' +
        ' 1.1193,2.5 2.5,2.5 H 52 Z"/>'
      
        #9#9#9'<path fill="#fafafa" d="m37 7v12.5c0 1.3808 1.1193 2.5 2.5 2.' +
        '5h12.5l-15-15z"/>'
      
        #9#9#9'<text font-family="Segoe UI" font-size="6" style="fill:red;fo' +
        'nt-weight: bold;">'
      ''
      #9#9#9#9'<xsl:if test="a:FatturaElettronica">'
      ''
      #9#9#9#9#9'<tspan x="13" y="45">'
      #9#9#9#9#9#9'<!--Cliente-->'
      
        #9#9#9#9#9#9'<xsl:value-of select="a:FatturaElettronica/FatturaElettron' +
        'icaHeader/CedentePrestatore/DatiAnagrafici[1]/Anagrafica/Denomin' +
        'azione"/>'
      #9#9#9#9#9'</tspan>'
      ''
      #9#9#9#9#9'<tspan x="13" y="15">'
      #9#9#9#9#9#9'<xsl:variable name="TD">'
      
        #9#9#9#9#9#9#9'<xsl:value-of select="a:FatturaElettronica/FatturaElettro' +
        'nicaBody[1]/DatiGenerali/DatiGeneraliDocumento/TipoDocumento"/>'
      #9#9#9#9#9#9'</xsl:variable>'
      #9#9#9#9#9#9'<xsl:choose>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD01'#39'">Fattura</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD02'#39'">Acc/Fatt.</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD03'#39'">Acc/Parc.</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD04'#39'">N.credito</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD05'#39'">N.debito</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD06'#39'">Parcella</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD16'#39'">Rev.charge</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD17'#39'">Autof/estero</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD18'#39'">Fatt.CEE</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD19'#39'">Ex art.17</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD20'#39'">AutoFattura</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD21'#39'">AutoFattura</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD22'#39'">Beni Depo.IVA</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD23'#39'">Beni Depo.IVA</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD24'#39'">Fatt.Diff.</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD25'#39'">Fatt.Diff.</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD26'#39'">Cess.Beni</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39'TD27'#39'">Autoconsumo</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:when test="$TD='#39#39'">'
      #9#9#9#9#9#9#9'</xsl:when>'
      #9#9#9#9#9#9'</xsl:choose>'
      #9#9#9#9#9'</tspan>'
      #9#9#9#9#9'<tspan x="13" y="25">'
      
        #9#9#9#9#9#9'<xsl:value-of select="a:FatturaElettronica/FatturaElettron' +
        'icaBody[1]/DatiGenerali/DatiGeneraliDocumento/Numero"/>'
      #9#9#9#9#9'</tspan>'
      #9#9#9#9#9'<tspan x="13" y="35">'
      #9#9#9#9#9#9'<xsl:call-template name="FormatDateIta">'
      
        #9#9#9#9#9#9#9'<xsl:with-param name="DateTime" select="a:FatturaElettron' +
        'ica/FatturaElettronicaBody[1]/DatiGenerali/DatiGeneraliDocumento' +
        '/Data"/>'
      #9#9#9#9#9#9'</xsl:call-template>'
      #9#9#9#9#9'</tspan>'
      #9#9#9#9#9'<tspan x="13" y="55">'
      
        #9#9#9#9#9#9'<xsl:for-each select="a:FatturaElettronica/FatturaElettron' +
        'icaBody[1]/DatiPagamento">'
      #9#9#9#9#9#9#9#9'<xsl:for-each select="DettaglioPagamento">'
      
        #9#9#9#9#9#9#9#9#9'  <xsl:value-of select="format-number(sum(ImportoPagame' +
        'nto), '#39#8364' ###.###.##0,00'#39', '#39'euro'#39')"/>'
      #9#9#9#9#9#9#9#9'</xsl:for-each>'
      #9#9#9#9#9#9#9'<!--'
      #9#9#9#9#9#9#9#9#9'<xsl:if test="ImportoPagamento">'
      
        #9#9#9#9#9#9#9#9#9'<xsl:value-of select="format-number(ImportoPagamento, '#39 +
        '###.###.##0,00'#39', '#39'euro'#39')"/>'
      #9#9#9#9#9#9#9#9'</xsl:if>'
      #9#9#9#9#9#9#9'</xsl:for-each>'
      #9#9#9#9#9#9#9'-->'
      #9#9#9#9#9#9'</xsl:for-each>'
      #9#9#9#9#9'</tspan>'
      #9#9#9#9'</xsl:if>'
      #9#9#9'</text>'
      
        #9#9#9'<path style="opacity:0.2;fill:#ffffff" d="m 14.5,6.9999999 c ' +
        '-1.385,0 -2.5,1.115 -2.5,2.5 V 10.5 C 12,9.1149999 13.115,7.9999' +
        '999 14.5,7.9999999 H 37 c 0,-1 0,0 0,-1 z"/>'
      #9#9'</svg>'
      #9'</xsl:template>'
      '</xsl:stylesheet>')
    Left = 35
    Top = 22
    DOMVendorDesc = 'MSXML'
  end
  object SourceXML: TXMLDocument
    Left = 40
    Top = 80
  end
end
