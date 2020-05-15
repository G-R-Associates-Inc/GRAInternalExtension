/**
*   Documentation Section
*       GRALE01 - 01/08/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*               - Added fields "US Country/Region Code", "Canada Country/Region Code", "Provincial Tax Area Code", and "Mexico Country/Region Code" according to definition from NAV 2009
*/
tableextension 50112 tXCompanyInformation extends "Company Information"
{
    fields
    {
        field(50000; "US Country/Region Code"; Code[10])
        {
            Caption = 'US Country/Region Code';
            FieldClass = Normal;
        }

        field(50001; "Canada Country/Region Code"; Code[10])
        {
            Caption = 'Canada Country/Region Code';
            FieldClass = Normal;

        }

        field(50002; "Mexico Country/Region Code"; Code[10])
        {
            Caption = 'Mexico Country/Region Code';
            FieldClass = Normal;
        }
    }
}