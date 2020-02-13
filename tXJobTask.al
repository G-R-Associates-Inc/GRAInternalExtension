/**
*   Documentation Section
*       GRALE01 - 12/24/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*               - Added field "Chargeable" according to definition from NAV 2009
*/
tableextension 50110 tXJobTask extends "Job Task"
{
    fields
    {
        field(50000; "Chargeable"; Boolean)
        {
            Caption = 'Chargeable';
            FieldClass = Normal;
        }
    }
}