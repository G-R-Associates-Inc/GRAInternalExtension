/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created table according to definition from NAV 2009.
*/
table 50105 "Sales Tax Amount Line"
{

    fields
    {
        field(1; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            FieldClass = Normal;
            TableRelation = "Tax Area";
        }

        field(2; "Tax Jurisdiction Code"; Code[10])
        {
            Caption = 'Tax Jurisdiction Code';
            FieldClass = Normal;
            TableRelation = "Tax Jurisdiction";
        }

        field(3; "Tax %"; Decimal)
        {
            Caption = 'Tax %';
            FieldClass = Normal;
            Editable = false;

        }

        field(4; "Tax Base Amount"; Decimal)
        {
            Caption = 'Tax Base Amount';
            FieldClass = Normal;
            Editable = false;
        }

        field(5; "Tax Amount"; Decimal)
        {
            Caption = 'Tax Amount';
            FieldClass = Normal;
        }

        field(6; "Amount Including Tax"; Decimal)
        {
            Caption = 'Amount Including Tax';
            FieldClass = Normal;
            Editable = false;
        }

        field(7; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            FieldClass = Normal;
            Editable = false;
        }

        field(10; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            FieldClass = Normal;
            Editable = false;
            TableRelation = "Tax Group";
        }

        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
            FieldClass = Normal;
            Editable = false;
        }

        field(12; Modified; Boolean)
        {
            Caption = 'Modified';
            FieldClass = Normal;
        }

        field(13; "Use Tax"; Boolean)
        {
            Caption = 'Use Tax';
            FieldClass = Normal;
        }

        field(14; "Calculated Tax Amount"; Decimal)
        {
            Caption = 'Calculated Tax Amount';
            FieldClass = Normal;
            Editable = false;
        }

        field(15; "Tax Difference"; Decimal)
        {
            Caption = 'Tax Difference';
            FieldClass = Normal;
            Editable = false;
        }

        field(16; "Tax Type"; Option)
        {
            Caption = 'Tax Type';
            FieldClass = Normal;
            OptionMembers = "Sales and Use Tax","Excise Tax","Sales Tax Only","Use Tax Only";
            OptionCaption = 'Sales and Use Tax,Excise Tax,Sales Tax Only,Use Tax Only';
        }

        field(17; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
            FieldClass = Normal;
        }

        field(20; "Tax Area Code for Key"; Code[20])
        {
            Caption = 'Tax Area Code for Key';
            FieldClass = Normal;
            TableRelation = "Tax Area";
        }

        field(25; "Invoice Discount Amount"; Decimal)
        {
            Caption = 'Invoice Discount Amount';
            FieldClass = Normal;
            Editable = false;
        }

        field(26; "Inv. Disc. Base Amount"; Decimal)
        {
            Caption = 'Inv. Disc. Base Amount';
            FieldClass = Normal;
            Editable = false;
        }

        field(10010; "Expense/Capitalize"; Boolean)
        {
            Caption = 'Expense/Capitalize';
            FieldClass = Normal;
        }

        field(10020; "Print Order"; Integer)
        {
            Caption = 'Print Order';
            FieldClass = Normal;
        }

        field(10030; "Print Description"; Text[30])
        {
            Caption = 'Print Description';
            FieldClass = Normal;
        }

        field(10040; "Calculation Order"; Integer)
        {
            Caption = 'Calculation Order';
            FieldClass = Normal;
        }

        field(10041; "Round Tax"; Option)
        {
            Caption = 'Round Tax';
            FieldClass = Normal;
            OptionMembers = "To Nearest",Up,Down;
            OptionCaption = 'To Nearest,Up,Down';
        }

        field(10042; "Is Report-to Jurisdiction"; Boolean)
        {
            Caption = 'Is Report-to Jurisdiction';
            FieldClass = Normal;
            Editable = false;
        }
    }

    keys
    {
        key(PrimKey; "Tax Area Code for Key", "Tax Jurisdiction Code", "Tax %", "Tax Group Code", "Expense/Capitalize", "Tax Type", "Use Tax")
        {
            Clustered = true;
        }

        key(Key2; "Print Order", "Tax Area Code for Key", "Tax Jurisdiction Code")
        {
        }

        key(Key3; "Tax Area Code for Key", "Tax Group Code", "Tax Type", "Calculation Order")
        {
        }
    }
}