/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created table according to definition from NAV 2009.
*/
table 50101 "Customer Login"
{

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            NotBlank = true;
            FieldClass = Normal;
        }

        field(2; "Line No."; Integer)
        {
            FieldClass = Normal;
        }

        field(3; "Login Type"; Option)
        {
            OptionMembers = " ",RDP,Windows,Navision,VPN;
            OptionCaptionML = ENU = ' ,RDP,Windows,Navision,VPN';
            FieldClass = Normal;
        }

        field(4; Username; Text[50])
        {
            FieldClass = Normal;
        }

        field(5; Password; Text[20])
        {
            FieldClass = Normal;
        }

        field(6; "Website/URL"; Text[250])
        {
            FieldClass = Normal;
        }

        field(10; "Comments"; Text[250])
        {
            FieldClass = Normal;
        }
    }

    keys
    {
        key(PrimKey; "Customer No.", "Line No.")
        {
            Clustered = true;
        }
    }
}