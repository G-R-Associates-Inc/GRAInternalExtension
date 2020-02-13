/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created page according to definition from NAV 2009.
*/

page 50101 "Timesheet History"
{
    SourceTable = "Job Ledger Entry";
    SourceTableView = sorting("Document No.", "Posting Date");
    Editable = false;
    PageType = List;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Document No."; "Document No.")
                {

                }

                field("Posting Date"; "Posting Date")
                {

                }

                field("Job No."; "Job No.")
                {

                }

                field("Job Task No."; "Job Task No.")
                {

                }

                field(Description; Description)
                {

                }

                field(Quantity; Quantity)
                {

                }

                field(Chargeable; Chargeable)
                {

                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {

                }
            }

        }
    }
}