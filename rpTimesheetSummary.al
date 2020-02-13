/**
*   Documentation Section
*       GRALE01 - 1/8/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created report according to definition from NAV 2009 (ID 50002).
*/

report 50104 "Timesheet Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportsLayout/TimesheetSummary.rdl';
    dataset
    {
        dataitem("Job Journal Line"; "Job Journal Line")
        {
            //DataItemTableView = sorting("Job No."); //Currently it's not supported to define non-primary key in tableextension
            RequestFilterFields = "Job No.";

            column(ReportNameCaption; ReportNameCaption)
            {

            }

            column(PageCaption; PageCaption)
            {

            }

            column(DocumentDateCaption; DocumentDateCaption)
            {

            }

            column(DocumentNoCaption; DocumentNoCaption)
            {

            }

            column(JobNoCaption; JobNoCaption)
            {

            }

            column(JobTaskNoCaption; JobTaskNoCaption)
            {

            }

            column(DescriptionCaption; DescriptionCaption)
            {

            }

            column(QuantityCaption; QuantityCaption)
            {

            }

            column(ChargeableCaption; ChargeableCaption)
            {

            }

            column(CustomerNameCaption; CustomerNameCaption)
            {

            }

            column(TotalFor; TotalFor)
            {

            }
            column(TotForTimesheetCaption; TotForTimesheetCaption)
            {

            }

            column(BillableCaption; BillableCaption)
            {

            }

            column(NonBillableCaption; NonBillableCaption)
            {

            }

            column(TotalCaption; TotalCaption)
            {

            }

            column(Company; CompanyName)
            {

            }

            column(UserRanReport; UserId)
            {

            }

            column(ReportRunningDate; Today)
            {

            }

            column(Job_No_; Job."No.")
            {

            }

            column(Bill_To_Customer_No_; Job."Bill-to Customer No.")
            {

            }

            column(Bill_to_Name; Job."Bill-to Name")
            {

            }
            column(Document_Date; "Document Date")
            {

            }

            column(Document_No_; "Document No.")
            {

            }

            column(Job_No_2_; "Job No.")
            {

            }

            column(Job_Task_No_; "Job Task No.")
            {

            }

            column(Description; Description)
            {

            }

            column(Quantity; Quantity)
            {

            }

            column(Chargeable; Chargeable)
            {

            }

            column(BillableHours; BillableHours)
            {

            }

            column(NonBillableHours; NonBillableHours)
            {

            }

            trigger OnPreDataItem();
            begin
                LastFieldNo := FieldNo("Job No.");

                if UserSetup."Jobs Manager" = false then
                    SetRange("No.", UserSetup."Linked Resource No.");
            end;

            trigger OnAfterGetRecord();
            begin
                Job.Get("Job No.");

                if "Job Journal Line".Chargeable = true then
                    BillableHours += Quantity
                else
                    NonBillableHours += Quantity;
            end;
        }

    }

    trigger OnInitReport();
    begin
        UserSetup.Get(UserId);
    end;

    VAR
        Job: Record Job;
        UserSetup: Record "User Setup";
        FooterPrinted: Boolean;
        BillableHours: Decimal;
        NonBillableHours: Decimal;
        LastFieldNo: Integer;
        TotalFor: TextConst ENU = 'Total for ';
        DocumentDateCaption: TextConst ENU = 'Document Date';
        DocumentNoCaption: TextConst ENU = 'Document No.';
        JobNoCaption: TextConst ENU = 'Job No.';
        JobTaskNoCaption: TextConst ENU = 'Job Task No.';
        DescriptionCaption: TextConst ENU = 'Description';
        QuantityCaption: TextConst ENU = 'Quantity';
        ChargeableCaption: TextConst ENU = 'Chargeable';
        CustomerNameCaption: TextConst ENU = 'Customer Name';
        TotForTimesheetCaption: TextConst ENU = 'Total For Timesheet';
        BillableCaption: TextConst ENU = 'Billable:';
        NonBillableCaption: TextConst ENU = 'Non-Billable:';
        TotalCaption: TextConst ENU = 'Total:';
        PageCaption: TextConst ENU = 'Page';
        ReportNameCaption: TextConst ENU = 'Job Journal Line';





}