/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created table according to definition from NAV 2009.
*/
table 50102 "60 Absolute E-Mail Info"
{

    fields
    {
        field(1; "Suite No."; Code[10])
        {
            NotBlank = true;
            FieldClass = Normal;
        }

        field(2; "Owner Name"; Text[250])
        {
            FieldClass = Normal;
        }

        field(3; "E-Mail Address"; Text[250])
        {
            FieldClass = Normal;
        }

        field(4; "E-Mail Sent"; Boolean)
        {
            FieldClass = Normal;
        }
    }

    keys
    {
        key(PrimKey; "Suite No.")
        {
            Clustered = true;
        }
    }
}