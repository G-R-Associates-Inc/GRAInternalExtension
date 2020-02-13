/**
*   Documentation Section
*       GRALE01 - 12/23/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*               - Added field "Description" according to definition from NAV 2009
*/

tableextension 50100 tXSalesHeader extends "Sales Header"
{
    fields
    {
        field(50000; Description; Text[250])
        {
            Caption = 'Description';
            FieldClass = Normal;
        }
    }

}