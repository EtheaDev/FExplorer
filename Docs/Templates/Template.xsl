<?xml version="1.0"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:b="http://www.fatturapa.gov.it/sdi/fatturapa/v1.1" xmlns:c="http://www.fatturapa.gov.it/sdi/fatturapa/v1.0" xmlns:a="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2" xmlns:d="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.0">
  <xsl:output method="html"/>
  <xsl:decimal-format name="euro" decimal-separator="," grouping-separator="."/>
  <xsl:template name="FormatDateIta">
    <xsl:param name="DateTime"/>
    <xsl:variable name="year" select="substring($DateTime,1,4)"/>
    <xsl:variable name="month" select="substring($DateTime,6,2)"/>
    <xsl:variable name="day" select="substring($DateTime,9,2)"/>
    <xsl:value-of select="$day"/>
    <xsl:value-of select="'-'"/>
    <xsl:value-of select="$month"/>
    <xsl:value-of select="'-'"/>
    <xsl:value-of select="$year"/>
  </xsl:template>
  <xsl:template name="FormatIVA">
    <xsl:param name="Natura"/>
    <xsl:param name="IVA"/>
    <xsl:choose>
      <xsl:when test="$Natura">
        <xsl:value-of select="$Natura"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$IVA">
          <xsl:value-of select="format-number($IVA,  '###.###.##0,00', 'euro')"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="FatturaElettronica">
    <xsl:param name="TipoFattura"/>
    <xsl:param name="IsFPRS"/>
    <xsl:param name="CessionarioCommittente"/>
    <xsl:param name="CedentePrestatore"/>
    <xsl:variable name="TD">
      <xsl:value-of select="$TipoFattura/FatturaElettronicaBody[1]/DatiGenerali/DatiGeneraliDocumento/TipoDocumento"/>
    </xsl:variable>
    <xsl:choose>
      <!-- Colore per Fattura:  blu scuro-->
      <xsl:when test="$TD='TD01' or $TD='TD02' or $TD='TD07'">
        <path fill="darkblue" d="m15 5 145 1.9e-6 45 45v145c0 5.54-4.46 10-10 10h-180c-5.54 0-10-4.46-10-10v-180c0-5.54 4.46-10 10-10z"/>
      </xsl:when>
      <!-- Colore per Fattura Differita: verde scuro-->
      <xsl:when test="$TD='TD24' or $TD='TD25'">
        <path fill="darkgreen" d="m15 5 145 1.9e-6 45 45v145c0 5.54-4.46 10-10 10h-180c-5.54 0-10-4.46-10-10v-180c0-5.54 4.46-10 10-10z"/>
      </xsl:when>
      <!-- Colore per tutti gli altri tipi: rosso scuro -->
      <xsl:otherwise>
        <path fill="darkred" d="m15 5 145 1.9e-6 45 45v145c0 5.54-4.46 10-10 10h-180c-5.54 0-10-4.46-10-10v-180c0-5.54 4.46-10 10-10z"/>
      </xsl:otherwise>
    </xsl:choose>
    <path d="m205 50c-12.913-0.0125-22.087 0.03402-35 0-8.1511-0.06177-10.038-5.8522-10-10v-35z" fill="#b1d1e0"/>
    <text font-family="Segoe UI" font-size="22" style="fill:white">
      <tspan x="13" y="40" font-size="32" font-weight="bold">
        <!--TIPO FATTURA-->
        <xsl:choose>
          <xsl:when test="$TD='TD01'">Fattura</xsl:when>
          <xsl:when test="$TD='TD02'">Acc/Fatt.</xsl:when>
          <xsl:when test="$TD='TD03'">Acc/Parc.</xsl:when>
          <xsl:when test="$TD='TD04'">N.credito</xsl:when>
          <xsl:when test="$TD='TD05'">N.debito</xsl:when>
          <xsl:when test="$TD='TD06'">Parcella</xsl:when>
          <xsl:when test="$TD='TD16'">Rev.charge</xsl:when>
          <xsl:when test="$TD='TD17'">Autof/estero</xsl:when>
          <xsl:when test="$TD='TD18'">Fatt.CEE</xsl:when>
          <xsl:when test="$TD='TD19'">Ex art.17</xsl:when>
          <xsl:when test="$TD='TD20'">AutoFattura</xsl:when>
          <xsl:when test="$TD='TD21'">AutoFattura</xsl:when>
          <xsl:when test="$TD='TD22'">Beni Depo.IVA</xsl:when>
          <xsl:when test="$TD='TD23'">Beni Depo.IVA</xsl:when>
          <xsl:when test="$TD='TD24'">Fatt.Diff.</xsl:when>
          <xsl:when test="$TD='TD25'">Fatt.Diff.</xsl:when>
          <xsl:when test="$TD='TD26'">Cess.Beni</xsl:when>
          <xsl:when test="$TD='TD27'">Autoconsumo</xsl:when>
          <!--FPRS-->
          <xsl:when test="$TD='TD07'">Fattura</xsl:when>
          <xsl:when test="$TD='TD08'">N.credito</xsl:when>
          <xsl:when test="$TD='TD09'">N.debito</xsl:when>
          <xsl:otherwise>*Error*</xsl:otherwise>
        </xsl:choose>
      </tspan>
      <tspan x="13" y="70">
        <!--NUMERO FATTURA-->
        <xsl:value-of select="$TipoFattura/FatturaElettronicaBody[1]/DatiGenerali/DatiGeneraliDocumento/Numero"/>
      </tspan>
      <tspan x="13" y="105" font-size="32" font-weight="bold">
        <!--DATA FATTURA-->
        <xsl:call-template name="FormatDateIta">
          <xsl:with-param name="DateTime" select="$TipoFattura/FatturaElettronicaBody[1]/DatiGenerali/DatiGeneraliDocumento/Data"/>
        </xsl:call-template>
      </tspan>
      <tspan x="13" y="130">
        <!--FORNITORE-->
        <xsl:value-of select="$CedentePrestatore"/>
      </tspan>
      <tspan x="13" y="160">
        <!--CLIENTE-->
        <xsl:value-of select="$CessionarioCommittente"/>
      </tspan>
      <tspan x="13" y="195" font-size="32" font-weight="bold">
        <xsl:choose>
          <!--IMPORTO Fattura elettronica semplificata: somma DatiBeniServizi/Importo-->
          <xsl:when test="$IsFPRS='1'">
            <xsl:for-each select="$TipoFattura/FatturaElettronicaBody[1]/DatiBeniServizi">
              <xsl:value-of select="format-number(sum(Importo), '€ ###.###.##0,00', 'euro')"/>
            </xsl:for-each>
          </xsl:when>
          <!--IMPORTO Fattura elettronica: se esiste lo legge da DatiGenerali/DatiGeneraliDocumento/ImportoTotaleDocumento-->
          <xsl:when test="$TipoFattura/FatturaElettronicaBody[1]/DatiGenerali/DatiGeneraliDocumento/ImportoTotaleDocumento">
            <xsl:value-of select="format-number($TipoFattura/FatturaElettronicaBody[1]/DatiGenerali/DatiGeneraliDocumento/ImportoTotaleDocumento, '€ ###.###.##0,00', 'euro')"/>
          </xsl:when>
          <xsl:otherwise>
            <!--IMPORTO Fattura elettronica: se non esiste somma DatiPagamento/DettaglioPagamento/ImportoPagamento-->
            <xsl:for-each select="$TipoFattura/FatturaElettronicaBody[1]/DatiPagamento">
              <xsl:for-each select="DettaglioPagamento">
                <xsl:value-of select="format-number(sum(ImportoPagamento), '€ ###.###.##0,00', 'euro')"/>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </tspan>
    </text>
    <path style="opacity:0.2;fill:#ffffff" d="1.115 -2.5,2.5 V 10.5 C 12,9.1149999 13.115,7.9999999 14.5,7.9999999 H 37 c 0,-1 0,0 0,-1 z"/>
  </xsl:template>
  <!--inizio rendering -->
  <xsl:template match="/">
    <svg width="210mm" height="210mm" version="1.1" viewBox="0 0 210 210" xmlns="http://www.w3.org/2000/svg">
      <xsl:choose>
        <xsl:when test="d:FatturaElettronicaSemplificata">
          <!--versione 1.0 SEMPLIFICATA-->
          <xsl:call-template name="FatturaElettronica">
            <xsl:with-param name="TipoFattura" select="d:FatturaElettronicaSemplificata"/>
            <xsl:with-param name="IsFPRS" select="1"/>
            <!--Cessionario Committente (cliente)-->
            <xsl:with-param name="CessionarioCommittente" select="d:FatturaElettronicaSemplificata/FatturaElettronicaHeader/CessionarioCommittente/AltriDatiIdentificativi/Denominazione"/>
            <!--Cedente/Prestatore (fornitore)-->
            <xsl:with-param name="CedentePrestatore" select="d:FatturaElettronicaSemplificata/FatturaElettronicaHeader/CedentePrestatore/Denominazione"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="c:FatturaElettronica">
          <!--versione 1.0-->
          <xsl:call-template name="FatturaElettronica">
            <xsl:with-param name="TipoFattura" select="c:FatturaElettronica"/>
            <xsl:with-param name="IsFPRS" select="0"/>
            <!--Cessionario Committente (cliente)-->
            <xsl:with-param name="CessionarioCommittente" select="c:FatturaElettronica/FatturaElettronicaHeader/CessionarioCommittente/DatiAnagrafici[1]/Anagrafica/Denominazione"/>
            <!--Cedente/Prestatore (fornitore)-->
            <xsl:with-param name="CedentePrestatore" select="c:FatturaElettronica/FatturaElettronicaHeader/CedentePrestatore/DatiAnagrafici[1]/Anagrafica/Denominazione"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="b:FatturaElettronica">
          <!--versione 1.1-->
          <xsl:call-template name="FatturaElettronica">
            <xsl:with-param name="TipoFattura" select="b:FatturaElettronica"/>
            <xsl:with-param name="IsFPRS" select="0"/>
            <!--Cessionario Committente (cliente)-->
            <xsl:with-param name="CessionarioCommittente" select="b:FatturaElettronica/FatturaElettronicaHeader/CessionarioCommittente/DatiAnagrafici[1]/Anagrafica/Denominazione"/>
            <!--Cedente/Prestatore (fornitore)-->
            <xsl:with-param name="CedentePrestatore" select="b:FatturaElettronica/FatturaElettronicaHeader/CedentePrestatore/DatiAnagrafici[1]/Anagrafica/Denominazione"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="FatturaElettronica">
            <!--versione 1.2-->
            <xsl:with-param name="TipoFattura" select="a:FatturaElettronica"/>
            <xsl:with-param name="IsFPRS" select="0"/>
            <!--Cessionario Committente (cliente)-->
            <xsl:with-param name="CessionarioCommittente" select="a:FatturaElettronica/FatturaElettronicaHeader/CessionarioCommittente/DatiAnagrafici[1]/Anagrafica/Denominazione"/>
            <!--Cedente/Prestatore (fornitore)-->
            <xsl:with-param name="CedentePrestatore" select="a:FatturaElettronica/FatturaElettronicaHeader/CedentePrestatore/DatiAnagrafici[1]/Anagrafica/Denominazione"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </svg>
  </xsl:template>
</xsl:stylesheet>
