/**
*   Documentation Section
*       GRALE01 - 12/23/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*               - Added field "Work Date" according to definition from NAV 2009
*/

tableextension 50104 tXSalesInvoiceLine extends "Sales Invoice Line"
{
    fields
    {
        field(50000; "Work Date"; Date)
        {
            Caption = 'Work Date';
            FieldClass = Normal;
        }

        field(50001; "Package Tracking No."; Text[30])
        {
            Caption = 'Package Tracking No.';
            FieldClass = Normal;
        }

        field(50002; "Kit Item"; Boolean)
        {
            Caption = 'Kit Item';
            FieldClass = Normal;
        }

        field(50003; "Build Kit"; Boolean)
        {
            Caption = 'Build Kit';
            FieldClass = Normal;
        }
    }

}