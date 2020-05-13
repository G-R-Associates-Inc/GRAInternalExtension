/**
*   Documentation Section
*       GRALE01 - 01/09/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created pageextension to add Timesheet reference to page
*
*       GRALE02 - 05/13/20 - Lina El Sadek, G.R. & Associates Inc.
*                - Added ApplicationArea to all actions, because they were not showing on the page
*/

pageextension 50108 pXJobList extends "Job List"
{
    actions
    {
        addafter("Create Job &Sales Invoice")
        {
            action(Timesheet)
            {
                ApplicationArea = Jobs; //GRALE02 - Add
                Image = Timesheet;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Timesheet';
                Caption = 'Timesheet';
                RunObject = page Timesheet;
            }

        }

        addafter("Job Task &Lines")
        {
            action("Job Task Worksheet")
            {
                ApplicationArea = Jobs; //GRALE02 - Add
                Image = Worksheet;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                //RunObject = page "Job Task Worksheet";
                //RunPageLink = "Job No." = field("No.");


                trigger OnAction()
                var
                    JobTaskWorksheet: Page "Job Task Worksheet";
                begin
                    JobTaskWorksheet.SetJobNo("No.");
                    JobTaskWorksheet.Run();
                end;
            }

            action("Customer Project Card")
            {
                ApplicationArea = Jobs; //GRALE02 - Add
                Image = Card;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Customer Project Card";

            }
        }

        addafter("Job - Suggested Billing")
        {
            action("Resource Actuals per Job")
            {
                ApplicationArea = Jobs; //GRALE02 - Add
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Resource Actuals per Job";
            }
        }
    }

}