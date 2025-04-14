<!-- Created with Jaspersoft Studio version 7.0.2.final using JasperReports Library version 7.0.2-31532122640f516c6d17238ae0e41a08113d5ac0  -->
<jasperReport name="JRCJ00000" language="groovy" pageWidth="990" pageHeight="595" orientation="Landscape" columnWidth="950" leftMargin="20" rightMargin="20" topMargin="20" bottomMargin="5" uuid="65efedb0-e2c0-413e-9c08-e23227d43651" summaryWithPageHeaderAndFooter="true">
	<property name="ireport.zoom" value="1.0"/>
	<property name="ireport.x" value="0"/>
	<property name="ireport.y" value="88"/>
	<parameter name="SUBREPORT_DIR" forPrompting="false" class="java.lang.String">
		<defaultValueExpression><![CDATA[]]></defaultValueExpression>
	</parameter>
	<parameter name="NU_SECUENCIA" class="java.lang.String"/>
	<query language="sql"><![CDATA[SELECT  to_char(sysdate,'DD') DIA,
to_char(sysdate,'MM') MES,
to_char(sysdate,'yyyy') ANO,
A.CD_ENTIDAD||'-'||A.CD_AREA||'-'||A.NU_POLIZA NU_POLIZA,
(SELECT DISTINCT cd_Egreso FROM CAJAEGRESO CE
  WHERE CE.CD_ENTIDAD= A.CD_ENTIDAD AND CE.CD_SUCURSAL = A.CD_SUCURSAL AND CE.NU_EGRESO = A.NU_EGRESO) cd_egreso,
A.CD_PERSONA_MEDIADOR,
(SELECT CD_MEDIADOR FROM PERSONAMEDIADOR WHERE CD_PERSONA_MEDIADOR=A.CD_PERSONA_MEDIADOR) CODIGO,
(SELECT TP_DOCUMENTO||'-'||NU_DOCUMENTO FROM PERSONA WHERE CD_PERSONA=A.CD_PERSONA_MEDIADOR) DOCUMENTO,
(SELECT NM_ZONARAZONSOCIAL FROM PERSONA WHERE CD_PERSONA=A.CD_PERSONA_MEDIADOR) PRODUCTOR,
nvl( (SELECT DISTINCT NVL(NU_FACTURA_GLOBAL,NU_FACTURA) FROM CAJAEGRESO CE
  WHERE CE.CD_ENTIDAD= A.CD_ENTIDAD AND CE.CD_SUCURSAL = A.CD_SUCURSAL AND CE.NU_EGRESO = A.NU_EGRESO),
A.CD_RECIBO) NU_FACTURA_RECIBO,
A.CD_RECIBO,
A.FE_MOVIMIENTO,
to_char(A.FE_MOVIMIENTO,'DD/MM/YYYY') FE_MOVIMIENTO,
to_char(B.FE_DESDE,'DD/MM/YYYY') FE_DESDE,
to_char(B.FE_HASTA,'DD/MM/YYYY') FE_HASTA,
(nvl(b.cd_sucursal_cobro,A.CD_SUCURSAL)||'-'||b.NU_INGRESO) NU_INGRESO,
(select to_char(fe_ingreso,'DD/MM/YYYY') from cajaingreso ci where ci.cd_entidad=b.cd_entidad and ci.cd_sucursal=nvl(b.cd_sucursal_cobro,a.cd_sucursal) and ci.nu_ingreso=b.nu_ingreso) Fe_ingreso,
A.TP_MOVIMIENTO_MEDIADOR,
C.DE_MOVIMIENTO_MEDIADOR,
INTEGRACION.DWH_ASEGURADO_TITULAR  (A.CD_ENTIDAD,  A.CD_AREA, A.NU_POLIZA, 'NOMBRE', NULL)  NOMBRE_ASEGURADO,
(select DE_SIGLAS_MONEDA FROM POLIZA P JOIN MONEDA M ON M.CD_MONEDA= P.CD_MONEDA WHERE A.CD_ENTIDAD=P.CD_ENTIDAD AND A.CD_AREA=P.CD_AREA AND A.NU_POLIZA=P.NU_POLIZA) MONEDA_POLIZA,
(select DE_SIGLAS_MONEDA FROM  MONEDA M WHERE  M.CD_MONEDA= A.CD_MONEDA_PAGO) MONEDA_PAGO,
A.CD_MONEDA,
A.MT_PRIMA as MT_PRIMA2,
CASE
WHEN A.CD_moneda = '02' AND A.CD_Moneda_pago = '01' THEN   A.MT_PRIMA * A.MT_TASA
WHEN A.CD_moneda = '02' AND A.CD_moneda_pago = '02' THEN   A.MT_PRIMA
WHEN A.CD_moneda = '01' AND A.CD_moneda_pago = '01' THEN   A.MT_PRIMA
ELSE A.MT_PRIMA
END   MT_PRIMA,
CASE
WHEN NVL( A.MT_COMISION,0) >0 THEN ROUND((A.MT_COMISION/A.MT_PRIMA)*100,0)
WHEN NVL( A.MT_COMISION,0) =0 THEN ROUND((A.MT_MOVIMIENTO_MEDIADOR/A.MT_PRIMA)*100,0)
END  PORC_COMISION,
CASE
WHEN NVL( A.MT_COMISION,0) >0 THEN A.MT_COMISION
WHEN NVL( A.MT_COMISION,0) =0 THEN A.MT_MOVIMIENTO_MEDIADOR
END MT_COMISION2,
CASE
WHEN A.CD_moneda = '02' AND A.CD_Moneda_pago = '01' THEN
                CASE
                WHEN NVL( A.MT_COMISION,0) >0 THEN A.MT_COMISION
                WHEN NVL( A.MT_COMISION,0) =0 THEN A.MT_MOVIMIENTO_MEDIADOR
                END * A.MT_TASA
WHEN A.CD_moneda = '02' AND A.CD_moneda_pago = '02' THEN
                CASE
                WHEN NVL( A.MT_COMISION,0) >0 THEN A.MT_COMISION
                WHEN NVL( A.MT_COMISION,0) =0 THEN A.MT_MOVIMIENTO_MEDIADOR
                END
WHEN A.CD_moneda = '01' AND A.CD_moneda_pago = '01' THEN
                CASE
                WHEN NVL( A.MT_COMISION,0) >0 THEN A.MT_COMISION
                WHEN NVL( A.MT_COMISION,0) =0 THEN A.MT_MOVIMIENTO_MEDIADOR
                END
ELSE
                CASE
                WHEN NVL( A.MT_COMISION,0) >0 THEN A.MT_COMISION
                WHEN NVL( A.MT_COMISION,0) =0 THEN A.MT_MOVIMIENTO_MEDIADOR
                END
END   MT_COMISION,

A.CD_ENTIDAD||'-'||A.CD_SUCURSAL||'-'||A.NU_EGRESO NU_EGRESO,
A.CD_ENTIDAD ENTIDAD,
(SELECT DE_PIE_PAGINA FROM ENTIDAD WHERE CD_ENTIDAD=A.CD_ENTIDAD) DE_PIE_PAGINA

FROM cajaegresomovimientomediador A
JOIN RECIBO B ON A.CD_ENTIDAD=B.CD_ENTIDAD AND A.CD_AREA=B.CD_AREA AND A.NU_POLIZA=B.NU_POLIZA AND A.CD_RECIBO=B.CD_RECIBO
JOIN CAJATIPOMOVIMIENTOMEDIADOR C ON C.CD_ENTIDAD=A.CD_ENTIDAD AND C.TP_MOVIMIENTO_MEDIADOR=A.TP_MOVIMIENTO_MEDIADOR
JOIN CAJAEGRESO CE ON CE.CD_ENTIDAD=A.CD_ENTIDAD AND CE.CD_SUCURSAL=A.CD_SUCURSAL AND CE.NU_EGRESO=A.NU_EGRESO
WHERE
CE.ST_EGRESO IN (1) AND
(A.CD_ENTIDAD, A.CD_MONEDA_PAGO, A.CD_PERSONA_MEDIADOR) IN (
                                              SELECT
                                              nm_parametro1 cd_entidad,
                                              nm_parametro2 cd_moneda,
                                              nm_parametro3 cd_persona_mediador
                                              FROM SIR.ORDENENPROCESO OP
                                              where OP.NU_SECUENCIA =$P{NU_SECUENCIA}
)
ORDER BY A.NU_EGRESO DESC]]></query>
	<field name="DIA" class="java.lang.String"/>
	<field name="MES" class="java.lang.String"/>
	<field name="ANO" class="java.lang.String"/>
	<field name="NU_POLIZA" class="java.lang.String"/>
	<field name="CD_EGRESO" class="java.math.BigDecimal"/>
	<field name="CD_PERSONA_MEDIADOR" class="java.math.BigDecimal"/>
	<field name="CODIGO" class="java.math.BigDecimal"/>
	<field name="DOCUMENTO" class="java.lang.String"/>
	<field name="PRODUCTOR" class="java.lang.String"/>
	<field name="NU_FACTURA_RECIBO" class="java.lang.String"/>
	<field name="CD_RECIBO" class="java.math.BigDecimal"/>
	<field name="FE_MOVIMIENTO" class="java.sql.Timestamp"/>
	<field name="FE_DESDE" class="java.lang.String"/>
	<field name="FE_HASTA" class="java.lang.String"/>
	<field name="NU_INGRESO" class="java.lang.String"/>
	<field name="FE_INGRESO" class="java.lang.String"/>
	<field name="TP_MOVIMIENTO_MEDIADOR" class="java.math.BigDecimal"/>
	<field name="DE_MOVIMIENTO_MEDIADOR" class="java.lang.String"/>
	<field name="NOMBRE_ASEGURADO" class="java.lang.String"/>
	<field name="MONEDA_POLIZA" class="java.lang.String"/>
	<field name="MONEDA_PAGO" class="java.lang.String"/>
	<field name="CD_MONEDA" class="java.math.BigDecimal"/>
	<field name="MT_PRIMA2" class="java.math.BigDecimal"/>
	<field name="MT_PRIMA" class="java.math.BigDecimal"/>
	<field name="PORC_COMISION" class="java.math.BigDecimal"/>
	<field name="MT_COMISION2" class="java.math.BigDecimal"/>
	<field name="MT_COMISION" class="java.math.BigDecimal"/>
	<field name="NU_EGRESO" class="java.lang.String"/>
	<field name="ENTIDAD" class="java.math.BigDecimal"/>
	<field name="DE_PIE_PAGINA" class="java.lang.String"/>
	<variable name="MT_PRIMA_1" calculation="Sum" class="java.math.BigDecimal">
		<expression><![CDATA[$F{MT_PRIMA}]]></expression>
	</variable>
	<variable name="MT_COMISION_1" calculation="Sum" class="java.math.BigDecimal">
		<expression><![CDATA[$F{MT_COMISION}]]></expression>
	</variable>
	<background splitType="Stretch"/>
	<title splitType="Stretch"/>
	<pageHeader height="118" splitType="Stretch">
		<element kind="rectangle" uuid="d8330f83-6481-47df-93f9-552dfab1c09f" x="0" y="78" width="950" height="13" backcolor="#CCCCCC"/>
		<element kind="staticText" uuid="08f4a29c-d9cd-457b-b41b-dea9fdc83c72" x="314" y="77" width="160" height="13" bold="true" hTextAlign="Center" vTextAlign="Middle">
			<text><![CDATA[Datos del Beneficiario]]></text>
		</element>
		<element kind="rectangle" uuid="55742702-1a61-4e6f-a549-a979e65208d3" x="0" y="91" width="117" height="26"/>
		<element kind="rectangle" uuid="55742702-1a61-4e6f-a549-a979e65208d3" x="100" y="91" width="712" height="26"/>
		<element kind="rectangle" uuid="55742702-1a61-4e6f-a549-a979e65208d3" x="812" y="91" width="138" height="26"/>
		<element kind="staticText" uuid="cf4e77d8-fd94-4d31-89cc-fa947cfbc362" x="5" y="92" width="95" height="12" fontSize="8.0" bold="true">
			<text><![CDATA[Código Productor]]></text>
		</element>
		<element kind="staticText" uuid="cf4e77d8-fd94-4d31-89cc-fa947cfbc362" x="125" y="92" width="57" height="12" fontSize="8.0" bold="true">
			<text><![CDATA[Productor]]></text>
		</element>
		<element kind="staticText" uuid="cf4e77d8-fd94-4d31-89cc-fa947cfbc362" x="549" y="92" width="48" height="12" fontSize="8.0" bold="true">
			<text><![CDATA[Documento]]></text>
		</element>
		<element kind="staticText" uuid="cf4e77d8-fd94-4d31-89cc-fa947cfbc362" x="821" y="93" width="77" height="12" fontSize="8.0" bold="true">
			<text><![CDATA[Moneda Pago]]></text>
		</element>
		<element kind="subreport" uuid="b9bb52a4-a59f-4370-8935-6e535a48ccab" x="5" y="10" width="176" height="55">
			<connectionExpression><![CDATA[$P{REPORT_CONNECTION}]]></connectionExpression>
			<expression><![CDATA["Logo_subreport1.jasper"]]></expression>
			<parameter name="CD_COMPANIA">
				<expression><![CDATA[$F{ENTIDAD}]]></expression>
			</parameter>
		</element>
		<element kind="staticText" uuid="83614935-7b98-4382-a32d-8997a7f9301f" x="354" y="10" width="277" height="42" fontSize="12.0" hTextAlign="Center" vTextAlign="Middle">
			<text><![CDATA[Egresos de Comisiones por Facturar]]></text>
		</element>
		<element kind="rectangle" uuid="36d85534-30f2-45eb-9b11-8ce1fc5f5de9" x="868" y="38" width="74" height="14" backcolor="#FFFFFF"/>
		<element kind="rectangle" uuid="36d85534-30f2-45eb-9b11-8ce1fc5f5de9" x="868" y="24" width="74" height="14" backcolor="#FFFFFF"/>
		<element kind="rectangle" uuid="36d85534-30f2-45eb-9b11-8ce1fc5f5de9" x="868" y="10" width="74" height="14" backcolor="#CCCCCC"/>
		<element kind="staticText" uuid="34dd77d2-9ed7-4a55-96c2-3004d2c9808d" mode="Transparent" x="868" y="10" width="74" height="14" fontSize="8.0" bold="true" italic="false" hTextAlign="Center" vTextAlign="Middle">
			<text><![CDATA[Fecha]]></text>
		</element>
		<element kind="textField" uuid="2b1e69e8-a4da-48f3-b774-ff178718f946" x="873" y="40" width="50" height="15" fontSize="8.0" vTextAlign="Top">
			<expression><![CDATA["Página "+$V{PAGE_NUMBER}+" de"]]></expression>
		</element>
		<element kind="textField" uuid="3180aee6-4fc3-4507-b696-65bb9c52b296" x="923" y="40" width="23" height="15" fontSize="8.0" evaluationTime="Report" vTextAlign="Top">
			<expression><![CDATA[" " + $V{PAGE_NUMBER}]]></expression>
		</element>
		<element kind="textField" uuid="ef19754e-ca19-489f-9326-3e50bce6ab2a" x="868" y="25" width="23" height="13" fontSize="8.0" hTextAlign="Center" vTextAlign="Middle">
			<expression><![CDATA[$F{DIA}]]></expression>
		</element>
		<element kind="textField" uuid="30e63c58-3db7-40e8-bd23-642174db7179" x="891" y="25" width="23" height="13" fontSize="8.0" hTextAlign="Center" vTextAlign="Middle">
			<expression><![CDATA[$F{MES}]]></expression>
		</element>
		<element kind="textField" uuid="e85fe855-0636-4113-aee9-979936df445d" x="914" y="25" width="28" height="13" fontSize="8.0" hTextAlign="Center" vTextAlign="Middle">
			<expression><![CDATA[$F{ANO}]]></expression>
		</element>
		<element kind="line" uuid="93882165-c259-49bf-b5a4-e05c32bdbbda" mode="Opaque" x="891" y="24" width="1" height="14"/>
		<element kind="line" uuid="93882165-c259-49bf-b5a4-e05c32bdbbda" mode="Opaque" x="914" y="24" width="1" height="14"/>
		<element kind="textField" uuid="27bc114f-f023-4267-8173-c6a8d83e0181" x="0" y="104" width="87" height="13" fontSize="8.0" blankWhenNull="true" hTextAlign="Center">
			<expression><![CDATA[$F{CODIGO}]]></expression>
		</element>
		<element kind="textField" uuid="bb48f146-abb0-4934-afde-a481a27dce5a" x="549" y="104" width="121" height="13" fontSize="8.0" blankWhenNull="true">
			<expression><![CDATA[$F{DOCUMENTO}]]></expression>
		</element>
		<element kind="textField" uuid="57703869-d42c-43c0-adb6-29c36d67a62c" x="125" y="104" width="294" height="13" fontSize="8.0" blankWhenNull="true">
			<expression><![CDATA[$F{PRODUCTOR}]]></expression>
		</element>
		<element kind="textField" uuid="486b26b3-7a81-477e-aa7f-78992c13189b" x="816" y="105" width="82" height="13" fontSize="8.0" blankWhenNull="true" hTextAlign="Center">
			<expression><![CDATA[$F{MONEDA_PAGO}]]></expression>
		</element>
	</pageHeader>
	<columnHeader height="16" splitType="Stretch">
		<element kind="rectangle" uuid="d8330f83-6481-47df-93f9-552dfab1c09f" x="0" y="2" width="950" height="14" backcolor="#CCCCCC"/>
		<element kind="staticText" uuid="c854e9c5-f40e-47e5-b648-d75021210ae6" x="-3" y="1" width="61" height="15" fontSize="8.0" bold="true" hTextAlign="Center" vTextAlign="Middle">
			<text><![CDATA[N° de Póliza]]></text>
		</element>
		<element kind="staticText" uuid="c854e9c5-f40e-47e5-b648-d75021210ae6" x="60" y="1" width="92" height="15" fontSize="8.0" bold="true" hTextAlign="Center" vTextAlign="Middle">
			<text><![CDATA[N° de Factura / Recibo]]></text>
		</element>
		<element kind="staticText" uuid="c854e9c5-f40e-47e5-b648-d75021210ae6" x="216" y="1" width="69" height="15" fontSize="8.0" bold="true" hTextAlign="Center" vTextAlign="Middle">
			<text><![CDATA[Vigencia Desde]]></text>
		</element>
		<element kind="staticText" uuid="c854e9c5-f40e-47e5-b648-d75021210ae6" x="156" y="1" width="60" height="15" fontSize="8.0" bold="true" hTextAlign="Center" vTextAlign="Middle">
			<text><![CDATA[Fecha Emisión]]></text>
		</element>
		<element kind="staticText" uuid="c854e9c5-f40e-47e5-b648-d75021210ae6" x="285" y="1" width="57" height="15" fontSize="8.0" bold="true" hTextAlign="Center" vTextAlign="Middle">
			<text><![CDATA[Vigencia Hasta]]></text>
		</element>
		<element kind="staticText" uuid="c854e9c5-f40e-47e5-b648-d75021210ae6" x="386" y="1" width="66" height="15" fontSize="8.0" bold="true" hTextAlign="Center" vTextAlign="Middle">
			<text><![CDATA[F. Ingreso]]></text>
		</element>
		<element kind="staticText" uuid="c854e9c5-f40e-47e5-b648-d75021210ae6" x="639" y="1" width="40" height="15" fontSize="8.0" bold="true" hTextAlign="Center" vTextAlign="Middle">
			<text><![CDATA[Mon. Pól.]]></text>
		</element>
		<element kind="staticText" uuid="c854e9c5-f40e-47e5-b648-d75021210ae6" x="691" y="1" width="57" height="15" fontSize="8.0" bold="true" hTextAlign="Center" vTextAlign="Middle">
			<text><![CDATA[Prima Cobrada]]></text>
		</element>
		<element kind="staticText" uuid="c854e9c5-f40e-47e5-b648-d75021210ae6" x="809" y="1" width="77" height="15" fontSize="8.0" bold="true" hTextAlign="Center" vTextAlign="Middle">
			<text><![CDATA[Comisión Generada]]></text>
		</element>
		<element kind="staticText" uuid="c854e9c5-f40e-47e5-b648-d75021210ae6" x="891" y="1" width="44" height="15" fontSize="8.0" bold="true" hTextAlign="Center" vTextAlign="Middle">
			<text><![CDATA[N° Egreso]]></text>
		</element>
		<element kind="staticText" uuid="e93414ca-55d2-4ff1-9365-136f92fd7a01" x="753" y="1" width="50" height="15" fontSize="8.0" bold="true" hTextAlign="Center" vTextAlign="Middle">
			<text><![CDATA[% Comisión]]></text>
		</element>
		<element kind="staticText" uuid="c854e9c5-f40e-47e5-b648-d75021210ae6" x="543" y="1" width="83" height="15" fontSize="8.0" bold="true" hTextAlign="Center" vTextAlign="Middle">
			<text><![CDATA[Nombre Asegurado]]></text>
		</element>
		<element kind="staticText" uuid="c854e9c5-f40e-47e5-b648-d75021210ae6" x="445" y="1" width="79" height="15" fontSize="8.0" bold="true" hTextAlign="Center" vTextAlign="Middle">
			<text><![CDATA[Tipo de Movimiento]]></text>
		</element>
		<element kind="staticText" uuid="c854e9c5-f40e-47e5-b648-d75021210ae6" x="342" y="1" width="53" height="15" fontSize="8.0" bold="true" hTextAlign="Center" vTextAlign="Middle">
			<text><![CDATA[N° Ingreso]]></text>
		</element>
	</columnHeader>
	<detail>
		<band height="19" splitType="Stretch">
			<element kind="textField" uuid="1f8fc7ef-fa04-4e24-873e-e0a0c43bf2ff" x="5" y="2" width="58" height="13" fontSize="8.0" blankWhenNull="true" vTextAlign="Middle">
				<expression><![CDATA[$F{NU_POLIZA}]]></expression>
			</element>
			<element kind="textField" uuid="a8e4c817-3c13-40f1-9b7a-9b2dccefb849" x="150" y="2" width="66" height="13" fontSize="8.0" pattern="dd/MM/yyyy" blankWhenNull="true" hTextAlign="Center">
				<expression><![CDATA[$F{FE_MOVIMIENTO}]]></expression>
			</element>
			<element kind="textField" uuid="ad571d11-544b-444c-a150-0e17fd08420e" x="233" y="2" width="41" height="13" fontSize="8.0" blankWhenNull="true" hTextAlign="Center">
				<expression><![CDATA[$F{FE_DESDE}]]></expression>
			</element>
			<element kind="textField" uuid="797f42f4-95c2-4d11-98fb-fa6ffb4ec5c2" x="291" y="2" width="46" height="13" fontSize="8.0" blankWhenNull="true" hTextAlign="Center">
				<expression><![CDATA[$F{FE_HASTA}]]></expression>
			</element>
			<element kind="textField" uuid="2186a83c-03ce-4aa6-b3c2-3bf2cf83c62b" x="346" y="2" width="44" height="13" fontSize="8.0" blankWhenNull="true" hTextAlign="Center">
				<expression><![CDATA[$F{NU_INGRESO}]]></expression>
			</element>
			<element kind="textField" uuid="6950b672-03a2-4fca-ab5f-a96bd084d4e0" x="396" y="2" width="46" height="13" fontSize="8.0" blankWhenNull="true" hTextAlign="Center">
				<expression><![CDATA[$F{FE_INGRESO}]]></expression>
			</element>
			<element kind="textField" uuid="1a34e2fe-bf12-4342-a80b-482acfb42c00" x="436" y="2" width="100" height="13" fontSize="8.0" blankWhenNull="true" hTextAlign="Center">
				<expression><![CDATA[$F{DE_MOVIMIENTO_MEDIADOR}]]></expression>
			</element>
			<element kind="textField" uuid="acbeed8f-24c5-475e-92ee-7d6b6d48f290" x="536" y="2" width="100" height="13" fontSize="8.0" blankWhenNull="true">
				<expression><![CDATA[$F{NOMBRE_ASEGURADO}]]></expression>
			</element>
			<element kind="textField" uuid="6cb486b2-d370-432a-83cf-af266a931a59" x="639" y="2" width="40" height="13" fontSize="8.0" blankWhenNull="true" hTextAlign="Center">
				<expression><![CDATA[$F{MONEDA_POLIZA}]]></expression>
			</element>
			<element kind="textField" uuid="091ef715-bccb-4525-86a6-0d4500ae1c2d" x="688" y="2" width="60" height="13" fontSize="8.0" pattern="#,##0.00" blankWhenNull="true" hTextAlign="Right">
				<expression><![CDATA[$F{MT_PRIMA}]]></expression>
			</element>
			<element kind="textField" uuid="12b8e66b-f6c1-4614-92d3-ed1abbdd3482" x="815" y="2" width="52" height="13" fontSize="8.0" pattern="#,##0.00" blankWhenNull="true" hTextAlign="Right">
				<expression><![CDATA[$F{MT_COMISION}]]></expression>
			</element>
			<element kind="textField" uuid="a41ce9ea-e0bf-4de6-ab01-6a0d19344832" x="762" y="2" width="38" height="13" fontSize="8.0" pattern="#,##0.00" blankWhenNull="true" hTextAlign="Center">
				<expression><![CDATA[$F{PORC_COMISION}]]></expression>
			</element>
			<element kind="textField" uuid="3efc7b07-9b7f-4a9c-ad3c-650eff5c46bb" x="881" y="2" width="66" height="13" fontSize="8.0" blankWhenNull="true" hTextAlign="Center">
				<expression><![CDATA[$F{NU_EGRESO}]]></expression>
			</element>
			<element kind="textField" uuid="c24cde1e-d060-43f6-88b1-79e19328c2a5" x="65" y="2" width="80" height="13" fontSize="8.0" hTextAlign="Center">
				<expression><![CDATA[$F{CD_RECIBO}]]></expression>
			</element>
		</band>
	</detail>
	<columnFooter splitType="Stretch"/>
	<pageFooter height="53" splitType="Stretch">
		<element kind="textField" uuid="77696a20-0101-4571-815e-4c42e68a7e5a" x="7" y="11" width="935" height="39" fontSize="7.0" blankWhenNull="true" hTextAlign="Justified">
			<expression><![CDATA[$F{DE_PIE_PAGINA}]]></expression>
		</element>
		<element kind="line" uuid="806f7fe3-713b-4f79-8df3-4c37b182901d" positionType="FixRelativeToBottom" stretchType="ContainerHeight" x="5" y="5" width="937" height="3"/>
	</pageFooter>
	<summary height="23" splitType="Stretch">
		<element kind="staticText" uuid="ae3692c8-880d-4fe9-a56d-e6acd28d88a2" x="633" y="5" width="38" height="13" fontSize="8.0" bold="true">
			<text><![CDATA[TOTAL]]></text>
		</element>
		<element kind="textField" uuid="7300bb07-922a-4632-b547-713e21a5dea6" x="679" y="5" width="69" height="13" fontSize="8.0" pattern="#,##0.00" blankWhenNull="true" hTextAlign="Right">
			<expression><![CDATA[$V{MT_PRIMA_1}]]></expression>
		</element>
		<element kind="textField" uuid="d2c013f0-8beb-4f63-a16a-f77556d9a4aa" x="800" y="5" width="67" height="13" fontSize="8.0" pattern="#,##0.00" blankWhenNull="true" hTextAlign="Right">
			<expression><![CDATA[$V{MT_COMISION_1}]]></expression>
		</element>
	</summary>
</jasperReport>
