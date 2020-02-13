/**
*   Documentation Section
*       GRALE01 - 01/08/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*/
tableextension 50119 tXSalesAndReceivablesSetup extends "Sales & Receivables Setup"
{
    fields
    {

        field(50000; "Components on Sales Orders"; Option)
        {
            Caption = 'Components on Sales Orders';
            FieldClass = Normal;
            OptionMembers = " ",Show,"Do Not Show";
            OptionCaption = ' ,Show,Do Not Show';
        }

        field(50001; "Components on Shipments"; Option)
        {
            Caption = 'Components on Shipments';
            FieldClass = Normal;
            OptionMembers = " ",Show,"Do Not Show";
            OptionCaption = ' ,Show,Do Not Show';
        }

        field(50002; "Components on Invoices"; Option)
        {
            Caption = 'Components on Invoices';
            FieldClass = Normal;
            OptionMembers = " ",Show,"Do Not Show";
            OptionCaption = ' ,Show,Do Not Show';
        }
    }
}