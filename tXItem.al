/**
*   Documentation Section
*       GRALE01 - 01/08/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*/
tableextension 50117 tXItem extends "Item"
{
    fields
    {
        field(50000; "Kit BOM No."; Code[20])
        {
            Caption = 'Kit BOM No.';
            FieldClass = Normal;
            TableRelation = "Production BOM Header" WHERE(Type = CONST(Kitting));
        }

        field(50001; "Kit Disassembly BOM No."; Code[20])
        {
            Caption = 'Print On Pick Ticket';
            FieldClass = Normal;
            TableRelation = "Production BOM Header" WHERE(Type = CONST(Kitting));
        }

        field(50002; "Components on Sales Orders"; Option)
        {
            Caption = 'Components on Sales Orders';
            FieldClass = Normal;
            OptionMembers = " ",Show,"Do Not Show";
            OptionCaption = ' ,Show,Do Not Show';
        }

        field(50003; "Components on Shipments"; Option)
        {
            Caption = 'Components on Shipments';
            FieldClass = Normal;
            OptionMembers = " ",Show,"Do Not Show";
            OptionCaption = ' ,Show,Do Not Show';
        }

        field(50004; "Components on Invoices"; Option)
        {
            Caption = 'Components on Invoices';
            FieldClass = Normal;
            OptionMembers = " ",Show,"Do Not Show";
            OptionCaption = ' ,Show,Do Not Show';
        }

        field(50005; "Components on Pick Tickets"; Option)
        {
            Caption = 'Components on Pick Tickets';
            FieldClass = Normal;
            OptionMembers = " ",Show,"Do Not Show";
            OptionCaption = ' ,Show,Do Not Show';
        }

        field(50006; "Roll-up Kit Pricing"; Option)
        {
            Caption = 'Roll-up Kit Pricing';
            FieldClass = Normal;
            OptionMembers = Never,Optional,Always;
            OptionCaption = 'Never,Optional,Always';
        }
    }
}