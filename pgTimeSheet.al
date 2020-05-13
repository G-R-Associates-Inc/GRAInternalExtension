/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created page according to definition from NAV 2009.
*/

page 50100 Timesheet
{
    CaptionML = ENU = 'Timesheet', ESM = 'Timesheet', FRC = 'Timesheet', ENC = 'Timesheet';
    SaveValues = true;
    SourceTable = "Job Journal Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    DataCaptionFields = "Journal Batch Name";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Submitted; Submitted)
                {
                    ApplicationArea = Jobs; //GRALE02 - Add
                    Editable = false;
                }
                field(Approved; Approved)
                {
                    ApplicationArea = Jobs; //GRALE02 - Add
                    Editable = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = Jobs; //GRALE02 - Add

                }

                field("Document Date"; "Document Date")
                {
                    ApplicationArea = Jobs; //GRALE02 - Add
                }

                field("Document No."; "Document No.")
                {
                    ApplicationArea = Jobs; //GRALE02 - Add
                }

                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = Jobs; //GRALE02 - Add
                    Visible = false;
                }

                field("Job No."; "Job No.")
                {
                    ApplicationArea = Jobs; //GRALE02 - Add
                    trigger OnValidate();
                    begin
                        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }

                field("Job Task No."; "Job Task No.")
                {
                    ApplicationArea = Jobs; //GRALE02 - Add
                }

                field(Type; Type)
                {
                    ApplicationArea = Jobs; //GRALE02 - Add
                    Visible = false;

                    trigger OnValidate();
                    begin
                        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
                    end;
                }

                field("No."; "No.")
                {
                    ApplicationArea = Jobs; //GRALE02 - Add
                    trigger OnValidate();
                    begin
                        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }

                field(Chargeable; Chargeable)
                {
                    ApplicationArea = Jobs; //GRALE02 - Add
                    CaptionML = ENU = 'Billable', ESM = 'Facturable', FRC = 'Facturable', ENC = 'Chargeable';
                }

                field(Description; Description)
                {
                    ApplicationArea = Jobs; //GRALE02 - Add

                }

                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = Jobs; //GRALE02 - Add

                }

                field(Quantity; Quantity)
                {
                    ApplicationArea = Jobs; //GRALE02 - Add

                }
            }

            field(JobDescription; JobDescription)
            {
                ApplicationArea = Jobs; //GRALE02 - Add
                Editable = false;
            }

            field(JobTaskDescription; JobTaskDescription)
            {
                ApplicationArea = Jobs; //GRALE02 - Add
                Editable = false;
                CaptionML = ENU = 'Account Name', ESM = 'Nombre cuenta', FRC = 'Nom du compte', ENC = 'Account Name';
            }

            field(TotalBillable; TotalBillable)
            {
                ApplicationArea = Jobs; //GRALE02 - Add
                Editable = false;
            }

            field(TotalNonBillable; TotalNonBillable)
            {
                ApplicationArea = Jobs; //GRALE02 - Add
                Editable = false;
            }

            field(TotalHours; TotalHours)
            {
                ApplicationArea = Jobs; //GRALE02 - Add
                Editable = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action("Retreive Timesheet History")
                {
                    ApplicationArea = Jobs; //GRALE02 - Add
                    Caption = 'Retreive Timesheet History';
                    Image = PostedTimeSheet;
                    Promoted = true;

                    trigger OnAction();
                    var
                        JobLedgerEntry: Record "Job Ledger Entry";
                        TimeSheetHistory: Page "Timesheet History";
                    begin
                        JobLedgerEntry.Reset;
                        JobLedgerEntry.SetRange("No.", UserSetup."Linked Resource No.");
                        JobLedgerEntry.SetRange("Entry Type", JobLedgerEntry."Entry Type"::Usage);
                        if JobLedgerEntry.FindSet then;
                        TimesheetHistory.SetTableView(JobLedgerEntry);
                        TimesheetHistory.RunModal;
                    end;
                }

                action("Timesheet Summary")
                {
                    ApplicationArea = Jobs; //GRALE02 - Add
                    Caption = 'Timesheet Summary';
                    Image = Timesheet;
                    Promoted = true;

                    trigger OnAction();
                    var
                        TimesheetSummary: report "Timesheet Summary";
                    begin
                        TimesheetSummary.SETTABLEVIEW(Rec);
                        TimesheetSummary.RUN;
                    end;
                }
            }

            group(Posting)
            {
                Caption = 'Posting';

                action("P&osting")
                {
                    ApplicationArea = Jobs; //GRALE02 - Add
                    CaptionML = ENU = 'P&osting', ESM = 'Control', FRC = 'Rapprocher', ENC = 'Reconcile';
                    Visible = false;

                    trigger OnAction();
                    begin
                        JobJnlReconcile.SetJobJnlLine(Rec);
                        JobJnlReconcile.Run();
                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = Jobs; //GRALE02 - Add
                    CaptionML = ENU = 'Test Report', ESM = 'Test', FRC = 'Tester le report', ENC = 'Test Report';
                    Visible = false;

                    trigger OnAction();
                    begin
                        ReportPrint.PrintJobJnlLine(Rec);
                    end;

                }

                action("Submit Timesheet")
                {
                    ApplicationArea = Jobs; //GRALE02 - Add
                    CaptionML = ENU = 'Submit Timesheet';
                    image = Post;
                    Promoted = true;

                    trigger OnAction();
                    var
                        TestJobJnlLine: Record "Job Journal Line";
                    begin
                        TestJobJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        TestJobJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");

                        if TestJobJnlLine.FIND('-') = FALSE then
                            ERROR(ERRORNOTHINGTOSUBMIT);

                        if CONFIRM(CONFIRMSUBMITTIMESHEET, TRUE, TestJobJnlLine."Document No.") = TRUE then begin
                            repeat
                                TestJobJnlLine.Submitted := TRUE;
                                TestJobJnlLine.Modify();
                            until TestJobJnlLine.NEXT = 0;

                            MESSAGE(MESSAGETIMESHEETSUBMITTED, TestJobJnlLine."Document No.");
                        end;
                    end;
                }

                action("Unsubmit Timesheet")
                {
                    ApplicationArea = Jobs; //GRALE02 - Add
                    CaptionML = ENU = 'Unsubmit Timesheet';
                    Image = Undo;
                    Promoted = true;

                    trigger OnAction();
                    var
                        TestJobJnlLine: Record "Job Journal Line";
                    begin
                        TestJobJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        TestJobJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");

                        if TestJobJnlLine.FIND('-') = FALSE then
                            ERROR(ERRORNOTHINGTOUNSUBMIT);

                        TestJobJnlLine.SETRANGE(Approved, TRUE);

                        IF TestJobJnlLine.FINDSET = TRUE THEN
                            ERROR(ERRORCANNOTUNSUBMIT, TestJobJnlLine."Document No.");

                        if CONFIRM(CONFIRMUNSUBMITTIMESHEET, TRUE, TestJobJnlLine."Document No.") = TRUE then begin
                            TestJobJnlLine.SETRANGE(Approved);
                            TestJobJnlLine.FIND('-');

                            REPEAT
                                TestJobJnlLine.Submitted := FALSE;
                                TestJobJnlLine.MODIFY;
                            UNTIL TestJobJnlLine.NEXT = 0;

                            MESSAGE(MESSAGETIMESHEETUNSUBMITTED, TestJobJnlLine."Document No.");
                        end;
                    end;
                }
            }
        }

    }

    trigger OnInit();
    begin
        // Retrieve the current user's User Setup information, including the linked resource no.
        UserSetup.GET(USERID);
    end;

    trigger OnOpenPage();
    var
        JnlSelected: Boolean;
    begin
        if IsOpenedFromBatch() then begin
            CurrentJnlBatchName := "Journal Batch Name";
            JobJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end else
        // Special logic that extends the template functionality to allow the user to open the job journal
        // using either a standard template or the timesheet template 
        begin
            CurrentJnlBatchName := UserId;
            DefaultBatchName := 'DEFAULT';
            //GRALE02 - Delete Start
            //Will call the custom template selection from the custom codeunit
            //JobJnlManagement.TemplateSelection(Page::Timesheet, false, Rec, JnlSelected);
            //GRALE02 - Delete End

            CuXJobJnlManagement.TemplateSelectionCustom(Page::Timesheet, false, Rec, JnlSelected); //GRALE02 - Add

            if JobJournalBatch.Get('DEFAULT', CurrentJnlBatchName) = true then
                JobJnlManagement.OpenJnl(CurrentJnlBatchName, Rec)
            else begin
                CuXJobJnlManagement.CreateNewBatch('DEFAULT', CurrentJnlBatchName, 'GJNL-JOB');
                JobJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            end;

            exit;
        end;

        //GRALE02 - Delete Start
        //Will call the custom template selection from the custom codeunit
        //JobJnlManagement.TemplateSelection(Page::"Job Journal", FALSE, Rec, JnlSelected);
        //GRALE02 - Delete End

        CuXJobJnlManagement.TemplateSelectionCustom(Page::"Job Journal", FALSE, Rec, JnlSelected); //GRALE02 - Add
        JobJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    trigger OnAfterGetRecord();
    begin
        ShowShortcutDimCode(ShortcutDimCode);
        // Refresh Billable counters
        RefreshBillableStatistics;
    end;

    trigger OnAfterGetCurrRecord();
    begin
        CuXJobJnlManagement.GetNamesWithTask(Rec, JobDescription, AccName, JobTaskDescription);
        // Refresh Billable counters
        RefreshBillableStatistics;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        SetUpNewLine(xRec);
        Clear(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveJobJnlLine: Codeunit "Job Jnl. Line-Reserve";
    begin
        Commit();
        if not ReserveJobJnlLine.DeleteLineConfirm(Rec) then
            exit(false);
        ReserveJobJnlLine.DeleteLine(Rec);
    end;


    var
        JobJnlReconcile: Page "Job Journal Reconcile";
        JobJournalBatch: Record "Job Journal Batch";
        JobJournalLine2: Record "Job Journal Line";
        UserSetup: Record "User Setup";
        JobJnlManagement: Codeunit JobJnlManagement;
        CuXJobJnlManagement: Codeunit CuXJobJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        JobDescription: Text[50];
        AccName: Text[50];
        JobTaskDescription: Text[50];
        CurrentJnlBatchName: Code[50];
        ShortcutDimCode: ARRAY[8] OF Code[20];
        DefaultBatchName: Code[10];
        OpenedFromBatch: Boolean;
        TotalBillable: Decimal;
        TotalNonBillable: Decimal;
        TotalHours: Decimal;
        ERRORENTRIESNOTAPPROVED: TextConst ENU = 'You cannot post Timesheet %1 until all time entires are approved.';
        CONFIRMSUBMITTIMESHEET: TextConst ENU = 'Are you sure you want to submit Timesheet %1 for approval?';
        MESSAGETIMESHEETSUBMITTED: TextConst ENU = 'Timesheet %1 has been submitted for approval.';
        CONFIRMUNSUBMITTIMESHEET: TextConst ENU = 'Are you sure you want to unsubmit Timesheet %1 for approval?';
        MESSAGETIMESHEETUNSUBMITTED: TextConst ENU = 'Timesheet %1 has been unsubmitted.';
        ERRORCANNOTUNSUBMIT: TextConst ENU = 'You cannot unsubmit Timesheet %1 because there are already approved time entries.';
        ERRORNOTHINGTOSUBMIT: TextConst ENU = 'There is nothing to submit.';
        ERRORNOTHINGTOUNSUBMIT: TextConst ENU = 'There is nothing to unsubmit.';

    PROCEDURE RefreshBillableStatistics();
    BEGIN
        // Update the hour counters whenever the user retrieves the next record in their timesheet
        // Here, we sum the number of billable hours
        JobJournalLine2.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Document No.", Chargeable);
        JobJournalLine2.COPYFILTERS(Rec);
        JobJournalLine2.SETRANGE("Journal Template Name", Rec."Journal Template Name");
        JobJournalLine2.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
        JobJournalLine2.SETRANGE(Chargeable, TRUE);
        JobJournalLine2.CALCSUMS(Quantity);
        TotalBillable := JobJournalLine2.Quantity;

        // Sum the number of non billable hours
        JobJournalLine2.SETRANGE(Chargeable, FALSE);
        JobJournalLine2.CALCSUMS(Quantity);
        TotalNonBillable := JobJournalLine2.Quantity;

        // Find the total number of hours in the timesheet
        TotalHours := TotalBillable + TotalNonBillable;
    END;

}