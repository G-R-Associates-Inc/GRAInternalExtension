/**
*   Documentation Section
*       GRALE01 - 01/08/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*               - Added fields "Print On..." according to definition from NAV 2009
*/
tableextension 50118 tXProductionBOMHeader extends "Production BOM Header"
{
    fields
    {
        field(50000; Type; Option)
        {
            Caption = 'Type';
            FieldClass = Normal;
            OptionMembers = Manufacturing,Kitting;
            OptionCaption = 'Manufacturing,Kitting';
        }
    }
}