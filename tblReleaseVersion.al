/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created table according to definition from NAV 2009.
*/
table 50100 "Release Version"
{
    LookupPageId = "Release Version List";
    DrillDownPageId = "Release Version List";

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            NotBlank = true;
            FieldClass = Normal;
        }

        field(2; "Version Tag No."; Code[20])
        {
            NotBlank = true;
            FieldClass = Normal;
        }

        field(3; "Release Date"; Date)
        {
            FieldClass = Normal;
        }

        field(4; Description; Text[80])
        {
            FieldClass = Normal;
        }

        field(5; Patch; Boolean)
        {
            FieldClass = Normal;
        }

        field(10; "Number of Objects"; Integer)
        {
            FieldClass = Normal;
        }

        field(12; "Customer Name"; Text[50])
        {
            //FieldClass = FlowField;
            //CalcFormula = sum (Customer.Name where("No." = field("Customer No.")));
        }
    }

    keys
    {
        key(PrimKey; "Customer No.", "Version Tag No.")
        {
            Clustered = true;
        }
    }
}