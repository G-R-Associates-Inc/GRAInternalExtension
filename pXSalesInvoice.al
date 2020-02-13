/**
*   Documentation Section
*       GRALE01 - 12/24/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created pageextension.
*               - Added field "Description" according to definition from NAV 2009
*/
pageextension 50100 pXSalesInvoice extends "Sales Invoice"
{
    layout
    {
        addafter("Sell-to Contact")
        {
            field(Description; Description)
            {
                Importance = Additional;
            }
        }
    }
}