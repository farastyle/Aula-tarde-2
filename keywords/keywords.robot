*** Settings ***
Documentation       Template keyword resource.

Variables           variables.py

Library    RPA.Browser.Selenium    auto_close=${FALSE}
Library    RPA.PDF
Library    RPA.HTTP
Library    RPA.Tables
Library    RPA.Archive
Library    RPA.FileSystem

*** Keywords ***
Entrar no side de comprar o robo
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order

Preenche of formulario para uma compra
    [Arguments]    ${compra}
    Click Element When Visible    //button[.='OK']
    Select From List By Value    head    ${compra}[Head]
    Select Radio Button    body    ${compra}[Body]
    Input Text   css:input[placeholder="Enter the part number for the legs"]    ${compra}[Legs]
    Input Text   address    ${compra}[Address]
    Click Element    preview
    Click Element    order
    ${ERRO}=  Is Element Visible    css:button[id="order-another"]
    WHILE    ${ERRO} == ${FALSE}
        Click Element    order
        ${ERRO}=  Is Element Visible    css:button[id="order-another"]
    END

    ${reciept_data}=  Get Element Attribute  //div[@id="receipt"]  outerHTML    
    Screenshot    css:div[id="robot-preview-image"]    ${CURDIR}${/}imagens${/}${compra}[Order number].png
    Html To Pdf    ${reciept_data}    ${CURDIR}${/}recibos${/}${compra}[Order number].pdf
    Add Watermark Image To Pdf    ${CURDIR}${/}imagens${/}${compra}[Order number].png    ${CURDIR}${/}recibos${/}${compra}[Order number].pdf    ${CURDIR}${/}recibos${/}${compra}[Order number].pdf
    Click Element    order-another

Download do arquivo CSV
    Download    https://robotsparebinindustries.com/orders.csv    overwrite=true

Ler tabela CSV
    ${compras}=    Read table from CSV    ${EXECDIR}//orders.csv  header=${TRUE}
    [Return]    ${compras}

Fazer as compras que veio na planilha
    [Arguments]    ${compras}
    FOR  ${compra}    IN    @{compras}
        Preenche of formulario para uma compra    ${compra}
    END

Compactar recibos
    Archive Folder With Zip  ${EXECDIR}${/}keywords${/}recibos  ${OUTPUT_DIR}${/}reciepts.zip
    Remove Files    ${EXECDIR}${/}keywords${/}recibos
    Remove Files    ${EXECDIR}${/}keywords${/}imagens

Fechar Browser    
    Close All Browsers



    