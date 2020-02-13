/**
*   Documentation Section
*       GRALE01 - 12/24/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created pageextension.
*               - Added field "Work Date" according to definition from NAV 2009
*/
pageextension 50101 pXSalesInvoiceSubform extends "Sales Invoice Subform"
{
    layout
    {
        addafter("VAT Prod. Posting Group")
        {
            field("Work Date"; "Work Date")
            {

            }
        }
    }
}