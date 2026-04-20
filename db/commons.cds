namespace anubhav.common;
using { Currency } from '@sap/cds/common';




type Gender : String(1) enum{
    male = 'M';
    female = 'F';
    undisclosed = 'U';
};


type AmountT : Decimal(10,2)@(
    Semantics.amount.currencyCode: 'CURRENCY_CODE',
    sap.unit:'CURRENCY_CODE'
);


aspect Amount: {
    CURRENCY: Currency;
    GROSS_AMOUNT: AmountT @(title : '{i18n>GROSS_AMOUNT}');
    NET_AMOUNT: AmountT @(title : '{i18n>NetAmount}');
    TAX_AMOUNT: AmountT @(title : '{i18n>TaxAmount}');
}




type Guid: String(32);
type PhoneNumber: String(30)@assert.format : '/^[6-9]\d{9}$/';
type Email: String(255)@assert.format : '^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+$';
