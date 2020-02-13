/**
*   Documentation Section
*       GRALE01 - 01/08/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*/
tableextension 50123 tXTaxJurisdiction extends "Tax Jurisdiction"
{
    fields
    {

        field(50000; "Country"; Option)
        {
            Caption = 'Country';
            FieldClass = Normal;
            OptionMembers = US,CA;
            OptionCaption = 'US,CA';
        }

        field(50001; "Print Order"; Integer)
        {
            Caption = 'Print Order';
            FieldClass = Normal;
        }

        field(50002; "Print Description"; Text[30])
        {
            Caption = 'Print Description';
            FieldClass = Normal;
        }
    }
}