/**
*   Documentation Section
*       GRALE01 - 12/24/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created pageextension.
*               - Added field "Work Date" according to definition from NAV 2009
*
*       GRALE02 - 05/13/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Added ApplicationArea property to fields and actions
*/
pageextension 50104 pXPostedSalesInvoiceSubform extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Work Date"; "Work Date")
            {
                ApplicationArea = All; //GRALE02 - Add
            }
        }
    }
}