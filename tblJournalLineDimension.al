/**
*   Documentation Section
*       GRALE01 - 01/08/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created table according to definition from NAV 2009.
*/
table 50103 "Journal Line Dimension"
{

    fields
    {
        field(1; "Table ID"; Integer)
        {
            CaptionML = ENU = 'Table ID';
            NotBlank = true;
            FieldClass = Normal;
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));
        }

        field(2; "Journal Template Name"; Code[10])
        {
            CaptionML = ENU = 'Journal Template Name';
            FieldClass = Normal;
            TableRelation = IF ("Table ID" = FILTER(81 | 221)) "Gen. Journal Template".Name ELSE
            IF ("Table ID" = CONST(83)) "Item Journal Template".Name ELSE
            IF ("Table ID" = CONST(207)) "Res. Journal Template".Name ELSE
            IF ("Table ID" = CONST(210)) "Job Journal Template".Name ELSE
            IF ("Table ID" = CONST(246)) "Req. Wksh. Template".Name ELSE
            IF ("Table ID" = CONST(5621)) "FA Journal Template".Name ELSE
            IF ("Table ID" = CONST(5635)) "Insurance Journal Template".Name;
        }

        field(3; "Journal Batch Name"; Code[10])
        {
            CaptionML = ENU = 'Journal Batch Name';
            FieldClass = Normal;
            TableRelation = IF ("Table ID" = FILTER(81 | 221)) "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name")) ELSE
            IF ("Table ID" = CONST(83)) "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name")) ELSE
            IF ("Table ID" = CONST(207)) "Res. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name")) ELSE
            IF ("Table ID" = CONST(210)) "Job Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name")) ELSE
            IF ("Table ID" = CONST(246)) "Requisition Wksh. Name".Name WHERE("Worksheet Template Name" = FIELD("Journal Template Name")) ELSE
            IF ("Table ID" = CONST(5621)) "FA Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name")) ELSE
            IF ("Table ID" = CONST(5635)) "Insurance Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }

        field(4; "Journal Line No."; Integer)
        {
            CaptionML = ENU = 'Journal Line No.';
            FieldClass = Normal;
        }

        field(5; "Allocation Line No."; Integer)
        {
            CaptionML = ENU = 'Allocation Line No.';
            FieldClass = Normal;
        }

        field(6; "Dimension Code"; Code[20])
        {
            CaptionML = ENU = 'Dimension Code';
            FieldClass = Normal;
            NotBlank = true;
            TableRelation = Dimension;
        }

        field(7; "Dimension Value Code"; Code[20])
        {
            CaptionML = ENU = 'Dimension Value Code';
            FieldClass = Normal;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dimension Code"));
        }

        field(8; "New Dimension Value Code"; Code[20])
        {
            CaptionML = ENU = 'New Dimension Value Code';
            FieldClass = Normal;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dimension Code"));
        }
    }

    keys
    {
        key(PrimKey; "Table ID", "Journal Template Name", "Journal Batch Name", "Journal Line No.", "Allocation Line No.", "Dimension Code")
        {
            Clustered = true;
        }

        key(Key2; "Dimension Code", "Dimension Value Code")
        {

        }
    }
}