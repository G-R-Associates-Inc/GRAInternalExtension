/**
*   Documentation Section
*       GRALE01 - 01/08/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*               - Added fields "Print On..." according to definition from NAV 2009
*/
tableextension 50116 tXSalesCommentLine extends "Sales Comment Line"
{
    fields
    {
        field(50000; "Print On Quote"; Boolean)
        {
            Caption = 'Print On Quote';
            FieldClass = Normal;
        }

        field(50001; "Print On Pick Ticket"; Boolean)
        {
            Caption = 'Print On Pick Ticket';
            FieldClass = Normal;
        }

        field(50002; "Print On Order Confirmation"; Boolean)
        {
            Caption = 'Print On Order Confirmation';
            FieldClass = Normal;
        }

        field(50003; "Print On Shipment"; Boolean)
        {
            Caption = 'Print On Shipment';
            FieldClass = Normal;
        }

        field(50004; "Print On Invoice"; Boolean)
        {
            Caption = 'Print On Invoice';
            FieldClass = Normal;
        }

        field(50005; "Print On Credit Memo"; Boolean)
        {
            Caption = 'Print On Credit Memo';
            FieldClass = Normal;
        }

        field(50006; "Print On Return Authorization"; Boolean)
        {
            Caption = 'Print On Return Authorization';
            FieldClass = Normal;
        }

        field(50007; "Print On Return Receipt"; Boolean)
        {
            Caption = 'Print On Return Receipt';
            FieldClass = Normal;
        }

    }
}