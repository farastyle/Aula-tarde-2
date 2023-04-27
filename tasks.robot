*** Settings ***
Documentation       Template robot main suite.

Library             Collections
Library             MyLibrary
Library    RPA.PDF
Resource            keywords.robot
Variables           variables.py


*** Tasks ***
Robo para comprar robos
    Entrar no side de comprar o robo
    Download do arquivo CSV
    ${compras}    Ler tabela CSV
    Fazer as compras que veio na planilha    ${compras}
    Compactar recibos
    [Teardown]   Fechar Browser 
    