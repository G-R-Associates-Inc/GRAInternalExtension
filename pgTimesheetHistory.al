/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created page according to definition from NAV 2009.
*
*       GRALE02 - 05/13/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Added ApplicationArea property to fields and actions
*/

page 50101 "Timesheet History"
{
    SourceTable = "Job Ledger Entry";
    SourceTableView = sorting("Document No.", "Posting Date");
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All; //GRALE02 - Add

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All; //GRALE02 - Add
                }

                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All; //GRALE02 - Add
                }

                field("Job No."; "Job No.")
                {
                    ApplicationArea = All; //GRALE02 - Add
                }

                field("Job Task No."; "Job Task No.")
                {
                    ApplicationArea = All; //GRALE02 - Add
                }

                field(Description; Description)
                {
                    ApplicationArea = All; //GRALE02 - Add
                }

                field(Quantity; Quantity)
                {
                    ApplicationArea = All; //GRALE02 - Add
                }

                field(Chargeable; Chargeable)
                {
                    ApplicationArea = All; //GRALE02 - Add
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = All; //GRALE02 - Add
                }
            }

        }
    }
}