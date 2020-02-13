/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created table according to definition from NAV 2009.
*/
table 50106 "Sales Tax Amount Difference"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            FieldClass = Normal;
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order";
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
        }

        field(2; "Document Product Area"; Option)
        {
            Caption = 'Document Product Area';
            FieldClass = Normal;
            OptionMembers = Sales,Purchase,Service,,,,"Posted Sale","Posted Purchase","Posted Service";
            OptionCaption = 'Sales,Purchase,Service,,,,Posted Sale,Posted Purchase,Posted Service';
        }

        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            FieldClass = Normal;
            TableRelation = IF ("Document Product Area" = CONST(Sales)) "Sales Header"."No." WHERE("Document Type" = FIELD("Document Type")) ELSE
            IF ("Document Product Area" = CONST(Purchase)) "Purchase Header"."No." WHERE("Document Type" = FIELD("Document Type")) ELSE
            IF ("Document Product Area" = CONST(Service)) "Service Header"."No." WHERE("Document Type" = FIELD("Document Type")) ELSE
            IF ("Document Type" = CONST(Invoice), "Document Product Area" = CONST("Posted Sale")) "Sales Invoice Header" ELSE
            IF ("Document Type" = CONST("Credit Memo"), "Document Product Area" = CONST("Posted Sale")) "Sales Cr.Memo Header" ELSE
            IF ("Document Type" = CONST(Invoice), "Document Product Area" = CONST("Posted Purchase")) "Purch. Inv. Header" ELSE
            IF ("Document Type" = CONST("Credit Memo"), "Document Product Area" = CONST("Posted Purchase")) "Purch. Cr. Memo Hdr." ELSE
            IF ("Document Type" = CONST(Invoice), "Document Product Area" = CONST("Posted Service")) "Service Invoice Header" ELSE
            IF ("Document Type" = CONST("Credit Memo"), "Document Product Area" = CONST("Posted Service")) "Service Cr.Memo Header";
        }

        field(5; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            FieldClass = Normal;
            TableRelation = "Tax Area";
        }

        field(6; "Tax Jurisdiction Code"; Code[10])
        {
            Caption = 'Tax Jurisdiction Code';
            FieldClass = Normal;
            TableRelation = "Tax Jurisdiction";
        }

        field(7; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            FieldClass = Normal;
            TableRelation = "Tax Group";
        }

        field(8; "Tax %"; Decimal)
        {
            Caption = 'Tax %';
            FieldClass = Normal;
            Editable = false;

        }

        field(9; "Expense/Capitalize"; Boolean)
        {
            Caption = 'Expense/Capitalize';
            FieldClass = Normal;
        }

        field(10; "Tax Type"; Option)
        {
            Caption = 'Tax Type';
            FieldClass = Normal;
            OptionMembers = "Sales and Use Tax","Excise Tax","Sales Tax Only","Use Tax Only";
            OptionCaption = 'Sales and Use Tax,Excise Tax,Sales Tax Only,Use Tax Only';
        }

        field(11; "Use Tax"; Boolean)
        {
            Caption = 'Use Tax';
            FieldClass = Normal;
        }

        field(15; "Tax Difference"; Decimal)
        {
            Caption = 'Tax Difference';
            FieldClass = Normal;
            Editable = false;
        }
    }

    keys
    {
        key(PrimKey; "Document Product Area", "Document Type", "Document No.", "Tax Area Code", "Tax Jurisdiction Code", "Tax %", "Tax Group Code", "Expense/Capitalize", "Tax Type", "Use Tax")
        {
            Clustered = true;
        }
    }
}