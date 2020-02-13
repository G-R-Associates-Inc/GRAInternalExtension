/**
*   Documentation Section
*       GRALE01 - 01/08/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*/
tableextension 50122 tXTaxDetail extends "Tax Detail"
{
    fields
    {

        field(50000; "Expense/Capitalize"; Boolean)
        {
            Caption = 'Expense/Capitalize';
            FieldClass = Normal;
        }
    }
}