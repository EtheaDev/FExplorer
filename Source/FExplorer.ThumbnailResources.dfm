object dmThumbnailResources: TdmThumbnailResources
  OldCreateOrder = False
  Height = 260
  Width = 341
  object DefaultTemplate: TXMLDocument
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
      #9'<xsl:if test="a:FatturaElettronica">'
      '        <xsl:variable name="TD">'
      
        '            <xsl:value-of select="a:FatturaElettronica/FatturaEl' +
        'ettronicaBody[1]/DatiGenerali/DatiGeneraliDocumento/TipoDocument' +
        'o"/>'
      '        </xsl:variable>'
      
        #9#9'<svg width="210mm" height="210mm" version="1.1" viewBox="0 0 2' +
        '10 210" xmlns="http://www.w3.org/2000/svg">'
      '        <xsl:choose>'
      '            <xsl:when test="$TD='#39'TD01'#39' or $TD='#39'TD02'#39'">'
      
        #9#9'       <path fill="darkblue" d="m15 5 145 1.9e-6 45 45v145c0 5' +
        '.54-4.46 10-10 10h-180c-5.54 0-10-4.46-10-10v-180c0-5.54 4.46-10' +
        ' 10-10z"/>'
      '            </xsl:when>'
      '            <xsl:when test="$TD='#39'TD24'#39' or $TD='#39'TD25'#39'">'
      
        #9#9'       <path fill="darkgreen" d="m15 5 145 1.9e-6 45 45v145c0 ' +
        '5.54-4.46 10-10 10h-180c-5.54 0-10-4.46-10-10v-180c0-5.54 4.46-1' +
        '0 10-10z"/>'
      '            </xsl:when>'
      '            <xsl:otherwise>'
      
        #9#9'       <path fill="darkred" d="m15 5 145 1.9e-6 45 45v145c0 5.' +
        '54-4.46 10-10 10h-180c-5.54 0-10-4.46-10-10v-180c0-5.54 4.46-10 ' +
        '10-10z"/>'
      '            </xsl:otherwise>'
      '        </xsl:choose>'
      
        #9#9'   <path d="m205 50c-12.913-0.0125-22.087 0.03402-35 0-8.1511-' +
        '0.06177-10.038-5.8522-10-10v-35z" fill="#b1d1e0"/>'
      
        #9#9'   <text font-family="Segoe UI" font-size="22" style="fill:whi' +
        'te">'
      #9#9#9#9#9'<tspan x="13" y="130">'
      #9#9#9#9#9#9'<!--FORNITORE-->'
      
        #9#9#9#9#9#9'<xsl:value-of select="a:FatturaElettronica/FatturaElettron' +
        'icaHeader/CedentePrestatore/DatiAnagrafici[1]/Anagrafica/Denomin' +
        'azione"/>'
      #9#9#9#9#9'</tspan>'
      #9#9#9#9#9'<tspan x="13" y="160">'
      #9#9#9#9#9#9'<!--CLIENTE-->'
      
        #9#9#9#9#9#9'<xsl:value-of select="a:FatturaElettronica/FatturaElettron' +
        'icaHeader/CessionarioCommittente/DatiAnagrafici[1]/Anagrafica/De' +
        'nominazione"/>'
      #9#9#9#9#9'</tspan>'
      #9#9#9#9#9'<tspan x="13" y="40" font-size="32"  font-weight="bold">'
      #9#9#9#9#9#9'<!--TIPO FATTURA-->'
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
      #9#9#9#9#9'<tspan x="13" y="70">'
      #9#9#9#9#9#9'<!--NUMERO FATTURA-->'
      
        #9#9#9#9#9#9'<xsl:value-of select="a:FatturaElettronica/FatturaElettron' +
        'icaBody[1]/DatiGenerali/DatiGeneraliDocumento/Numero"/>'
      #9#9#9#9#9'</tspan>'
      #9#9#9#9#9'<tspan x="13" y="105" font-size="32" font-weight="bold">'
      #9#9#9#9#9#9'<!--DATA FATTURA-->'
      #9#9#9#9#9#9'<xsl:call-template name="FormatDateIta">'
      
        #9#9#9#9#9#9#9'<xsl:with-param name="DateTime" select="a:FatturaElettron' +
        'ica/FatturaElettronicaBody[1]/DatiGenerali/DatiGeneraliDocumento' +
        '/Data"/>'
      #9#9#9#9#9#9'</xsl:call-template>'
      #9#9#9#9#9'</tspan>'
      #9#9#9#9#9'<tspan x="13" y="195" font-size="32"  font-weight="bold">'
      #9#9#9#9#9#9'<!--IMPORTO TOTALE-->'
      #9#9#9#9#9#9'<xsl:choose>'
      
        #9#9#9#9#9#9#9'<xsl:when test="a:FatturaElettronica/FatturaElettronicaBo' +
        'dy[1]/DatiGenerali/DatiGeneraliDocumento/ImportoTotaleDocumento"' +
        '>'
      
        #9#9#9#9#9#9#9#9'<xsl:value-of select="format-number(a:FatturaElettronica' +
        '/FatturaElettronicaBody[1]/DatiGenerali/DatiGeneraliDocumento/Im' +
        'portoTotaleDocumento, '#39#8364' ###.###.##0,00'#39', '#39'euro'#39')"/>'
      #9#9#9#9#9#9#9'</xsl:when>'
      #9#9#9#9#9#9#9'<xsl:otherwise>'
      
        #9#9#9#9#9#9#9'<xsl:for-each select="a:FatturaElettronica/FatturaElettro' +
        'nicaBody[1]/DatiPagamento">'
      #9#9#9#9#9#9#9#9#9'<xsl:for-each select="DettaglioPagamento">'
      
        #9#9#9#9#9#9#9#9#9#9'  <xsl:value-of select="format-number(sum(ImportoPagam' +
        'ento), '#39#8364' ###.###.##0,00'#39', '#39'euro'#39')"/>'
      #9#9#9#9#9#9#9#9#9'</xsl:for-each>'
      #9#9#9#9#9#9#9'</xsl:for-each>'
      #9#9#9#9#9#9#9'</xsl:otherwise>'
      #9#9#9#9#9#9'</xsl:choose>'
      #9#9#9#9#9'</tspan>'
      #9#9#9'</text>'
      
        #9#9#9'<path style="opacity:0.2;fill:#ffffff" d="m 14.5,6.9999999 c ' +
        '-1.385,0 -2.5,1.115 -2.5,2.5 V 10.5 C 12,9.1149999 13.115,7.9999' +
        '999 14.5,7.9999999 H 37 c 0,-1 0,0 0,-1 z"/>'
      #9#9'</svg>'
      #9#9#9#9'</xsl:if>'
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
