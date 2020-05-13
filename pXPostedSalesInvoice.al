/**
*   Documentation Section
*       GRALE01 - 12/24/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created pageextension.
*               - Added field "Description" according to definition from NAV 2009
*
*       GRALE02 - 05/13/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Added ApplicationArea property to fields and actions
*/
pageextension 50103 pXPostedSalesInvoice extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Sell-to Contact")
        {
            field(Description; Description)
            {
                ApplicationArea = All; //GRALE02 - Add
                Importance = Additional;
            }
        }
    }
}