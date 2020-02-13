/**
*   Documentation Section
*       GRALE01 - 12/23/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*               - Added field "Work Date" according to definition from NAV 2009
*/

tableextension 50101 tXSalesLine extends "Sales Line"
{
    fields
    {
        field(50000; "Work Date"; Date)
        {
            Caption = 'Work Date';
            FieldClass = Normal;
        }
    }

}