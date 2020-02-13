/**
*   Documentation Section
*       GRALE01 - 01/08/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*               - Added fields "Bank Communication", "Check Date Format", and "Check Date Separator" according to definition from NAV 2009
*/
tableextension 50114 tXCustomer extends Customer
{
    fields
    {
        field(50000; "Bank Communication"; Option)
        {
            Caption = 'Bank Communication';
            FieldClass = Normal;
            OptionMembers = "E English","F French","S Spanish";
            OptionCaption = 'E English,F French,S Spanisht';
        }

        field(50001; "Check Date Format"; Option)
        {
            Caption = 'Check Date Format';
            FieldClass = Normal;
            OptionMembers = " ","MM DD YYYY","DD MM YYYY","YYYY MM DD";
            OptionCaption = ' ,MM DD YYYY,DD MM YYYY,YYYY MM DD';
        }

        field(50002; "Check Date Separator"; Option)
        {
            Caption = 'Check Date Separator';
            FieldClass = Normal;
            OptionMembers = " ","-",".","/";
            OptionCaption = ' ,-,.,/';
        }

        field(50003; "Balance on Date"; Decimal)
        {
            Caption = 'Balance on Date';
            FieldClass = FlowField;
            CalcFormula = sum ("Detailed Cust. Ledg. Entry".Amount where("Customer No." = field("No."), "Posting Date" = field(Upperlimit("Date Filter")), "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"), "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"), "Currency Code" = field("Currency Filter")));
            Editable = false;
        }

        field(50004; "Balance on Date (LCY)"; Decimal)
        {
            Caption = 'Balance on Date ($)';
            FieldClass = FlowField;
            CalcFormula = sum ("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Customer No." = field("No."), "Posting Date" = field(Upperlimit("Date Filter")), "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"), "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"), "Currency Code" = field("Currency Filter")));
            Editable = false;
        }

        field(50005; "Tax Identification Type"; Option)
        {
            Caption = 'Tax Identification Type';
            FieldClass = Normal;
            OptionMembers = "Legal Entity","Natural Person";
            OptionCaption = 'Legal Entity,Natural Person';
        }

        field(50006; "Components on Sales Orders"; Option)
        {
            Caption = 'Components on Sales Orders';
            FieldClass = Normal;
            OptionMembers = " ",Show,"Do Not Show";
            OptionCaption = ' ,Show,Do Not Show';
            InitValue = Show;
        }

        field(50007; "Components on Shipments"; Option)
        {
            Caption = 'Components on Shipments';
            FieldClass = Normal;
            OptionMembers = " ",Show,"Do Not Show";
            OptionCaption = ' ,Show,Do Not Show';
            InitValue = Show;
        }

        field(50008; "Components on Invoices"; Option)
        {
            Caption = 'Components on Invoices';
            FieldClass = Normal;
            OptionMembers = " ",Show,"Do Not Show";
            OptionCaption = ' ,Show,Do Not Show';
            InitValue = Show;
        }

    }
}