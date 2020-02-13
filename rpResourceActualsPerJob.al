/**
*   Documentation Section
*       GRALE01 - 01/07/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created report according to definition from NAV 2009 (ID 50001).
*
*       GRALE02 - 01/15/20 - Lina El Sadek, G.R. & Associates Inc.
*                - Change the way the totals are calculated
*
*/

report 50103 "Resource Actuals per Job"
{
    Caption = 'Resource Actuals Per Job';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportsLayout/ResourceActualsPerJob.rdl';

    dataset
    {
        dataitem("Job Ledger Entry"; "Job Ledger Entry")
        {
            DataItemTableView = SORTING("No.", "Job No.", "Job Task No.") WHERE(Type = CONST(Resource), "Entry Type" = CONST(Usage));
            RequestFilterFields = "No.", "Job No.", "Document Date", Chargeable;

            column(No_; "No.")
            {

            }
            column(Job_No_; "Job No.")
            {

            }

            column(Job_Task_No_; "Job Task No.")
            {

            }

            column(Document_Date; "Document Date")
            {

            }

            column(Description; Description)
            {

            }

            column(Quantity; Quantity)
            {

            }

            column(Unit_Cost__LCY_; "Unit Cost (LCY)")
            {

            }

            column(Total_Cost__LCY_; "Total Cost (LCY)")
            {

            }

            column(Unit_Price__LCY_; "Unit Price (LCY)")
            {

            }

            column(Total_Price__LCY_; "Total Price (LCY)")
            {

            }

            column(Chargeable; Chargeable)
            {

            }

            column(Job_Description; Job.Description)
            {

            }

            column(Bill_To_Name; Job."Bill-to Name")
            {

            }

            column(JobManager; UserSetup."Jobs Manager")
            {

            }

            column(Resource_Name; Resource.Name)
            {

            }

            column(Billable_SubGroup; 'Billable: ' + FORMAT(TotalBillableForJob) + ' / Non-Billable: ' + FORMAT(TotalNonBillableForJob) + ' / Total: ' + FORMAT(Quantity))
            {

            }

            column(Billable_SubGroup2; 'Billable: ' + FORMAT(TotalBillableForJob) + ' / Non-Billable: ' + FORMAT(TotalNonBillableForJob) + ' / Total: ' + FORMAT(Quantity))
            {

            }

            column(TotalFor_SubGroup; TotalFor + Job.Description)
            {

            }

            column(TotalFor_SubGroup2; TotalFor + Job.Description)
            {

            }

            column(Resource_Group; 'Billable: ' + FORMAT(TotalBillableForResource) + ' / Non-Billable: ' + FORMAT(TotalNonBillableForResource) + ' / Total: ' + FORMAT(Quantity))
            {

            }

            column(Resource_Group2; 'Billable: ' + FORMAT(TotalBillableForResource) + ' / Non-Billable: ' + FORMAT(TotalNonBillableForResource) + ' / Total: ' + FORMAT(Quantity))
            {

            }

            column(TotalFor_Group; TotalFor + Resource.Name)
            {

            }

            column(TotalFor_Group2; TotalFor + Resource.Name)
            {

            }

            column(ResourceNoCaption; ResourceNoCaption)
            {

            }

            column(NoCaption; NoCaption)
            {

            }

            column(JobNoCaption; JobNoCaption)
            {

            }

            column(JobTaskNoCaption; JobTaskNoCaption)
            {

            }

            column(DocumentDateCaption; DocumentDateCaption)
            {

            }

            column(DescriptionCaption; DescriptionCaption)
            {

            }

            column(QuantityCaption; QuantityCaption)
            {

            }

            column(UnitCostCaption; UnitCostCaption)
            {

            }

            column(TotalCostCaption; TotalCostCaption)
            {

            }

            column(UnitPriceCaption; UnitPriceCaption)
            {

            }

            column(TotalUnitPriceCaption; TotalUnitPriceCaption)
            {

            }

            column(ChargeableCaption; ChargeableCaption)
            {

            }

            column(CustomerNameCaption; CustomerNameCaption)
            {

            }

            column(ReportNameCaption; ReportNameCaption)
            {

            }

            column(ReportRunOn; Today)
            {

            }

            column(UserRanReport; UserId)
            {

            }

            column(PageCaption; PageCaption)
            {

            }

            column(TableFilters; 'Table Filters:' + GetFilters)
            {

            }
            column(CompanyName; CompanyName)
            {

            }

            column(TotalBillableForJob; TotalBillableForJob)
            {

            }

            column(TotalNonBillableForJob; TotalNonBillableForJob)
            {

            }

            column(TotalBillableForResource; TotalBillableForResource)
            {

            }

            column(TotalNonBillableForResource; TotalNonBillableForResource)
            {

            }

            trigger OnPreDataItem();
            begin
                LastFieldNo := FIELDNO("Job No.");

                IF Find('-') THEN;
                PreviousResource := "No.";
                PreviousJob := "Job No.";

                if UserSetup."Jobs Manager" = false then
                    SETRANGE("No.", UserSetup."Linked Resource No.");
            end;

            trigger OnAfterGetRecord();
            begin

                Resource.Get("Job Ledger Entry"."No.");
                Job.Get("Job Ledger Entry"."Job No.");

                //GRALE02 - Delete Start
                //Changed the way the Total Billable/NonBillable for Job/Resource is calculated
                /*
                if PreviousResource <> "No." then begin
                    TotalBillableForJob := 0;
                    TotalNonBillableForJob := 0;
                    TotalBillableForResource := 0;
                    TotalNonBillableForResource := 0;
                    PreviousResource := "No.";
                    PreviousJob := "Job No.";
                end else
                    if PreviousJob <> "Job No." then begin
                        TotalBillableForJob := 0;
                        TotalNonBillableForJob := 0;
                        PreviousJob := "Job No.";
                    end;

                
                if Chargeable = true then begin
                    TotalBillableForJob += Quantity;
                    TotalBillableForResource += Quantity;
                end else begin
                    TotalNonBillableForJob += Quantity;
                    TotalNonBillableForResource += Quantity;
                end
                */
                //GRALE02 - Delete End

                //GRALE02 - Add Start
                TotalBillableForJob := 0;
                TotalNonBillableForJob := 0;
                TotalBillableForResource := 0;
                TotalNonBillableForResource := 0;
                if Chargeable = true then begin
                    TotalBillableForJob := Quantity;
                    TotalBillableForResource := Quantity;
                end else begin
                    TotalNonBillableForJob := Quantity;
                    TotalNonBillableForResource := Quantity;
                end
                //GRALE02 - Add End

            end;
        }
    }

    trigger OnInitReport();
    begin
        UserSetup.Get(USERID);
    end;


    VAR
        Resource: Record Resource;
        Job: Record Job;
        UserSetup: Record "User Setup";
        PreviousResource: Code[20];
        PreviousJob: Code[20];
        TotalBillableForJob: Decimal;
        TotalNonBillableForJob: Decimal;
        TotalBillableForResource: Decimal;
        TotalNonBillableForResource: Decimal;
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: TextConst ENU = 'Total for ';
        ResourceNoCaption: TextConst ENU = 'Resource No.:';
        NoCaption: TextConst ENU = 'No.';
        JobNoCaption: TextConst ENU = 'Job No.';
        JobTaskNoCaption: TextConst ENU = 'Job Task No.';
        DocumentDateCaption: TextConst ENU = 'Document Date';
        DescriptionCaption: TextConst ENU = 'Description';
        QuantityCaption: TextConst ENU = 'Quantity';
        UnitCostCaption: TextConst ENU = 'Unit Cost';
        TotalCostCaption: TextConst ENU = 'Total Cost';
        UnitPriceCaption: TextConst ENU = 'Unit Price';
        TotalUnitPriceCaption: TextConst ENU = 'Total Unit Price';
        ChargeableCaption: TextConst ENU = 'Billable';
        CustomerNameCaption: TextConst ENU = 'Customer Name:';
        ReportNameCaption: TextConst ENU = 'Resource Actuals per Job';
        PageCaption: TextConst ENU = 'Page ';


}