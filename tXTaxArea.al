/**
*   Documentation Section
*       GRALE01 - 01/08/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*/
tableextension 50120 tXTaxArea extends "Tax Area"
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

        field(50001; "Round Tax"; Option)
        {
            Caption = 'Round Tax';
            FieldClass = Normal;
            OptionMembers = "To Nearest",Up,Down;
            OptionCaption = 'To Nearest,Up,Down';
        }

        field(50002; "Use External Tax Engine"; Boolean)
        {
            Caption = 'Use External Tax Engine';
            FieldClass = Normal;
        }
    }
}