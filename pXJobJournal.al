/**
*   Documentation Section
*       GRALE01 - 12/24/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created pageextension.
*/
pageextension 50105 pXJobJournal extends "Job Journal"
{
    actions
    {
        addafter("Test Report")
        {
            action("Submit Timesheet")
            {
                CaptionML = ENU = 'Submit Timesheet';
                image = Post;
                //Promoted = true;

                trigger OnAction();
                var
                    TestJobJnlLine: Record "Job Journal Line";
                begin
                    TestJobJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    TestJobJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");

                    IF TestJobJnlLine.FIND('-') = FALSE THEN
                        ERROR(ERRORNOTHINGTOSUBMIT);

                    IF CONFIRM(CONFIRMSUBMITTIMESHEET, TRUE, TestJobJnlLine."Document No.") = TRUE THEN BEGIN
                        REPEAT
                            TestJobJnlLine.Submitted := TRUE;
                            TestJobJnlLine.MODIFY;
                        UNTIL TestJobJnlLine.NEXT = 0;

                        MESSAGE(MESSAGETIMESHEETSUBMITTED, TestJobJnlLine."Document No.");
                    END;

                end;
            }
            action("Unsubmit Timesheet")
            {
                CaptionML = ENU = 'Unsubmit Timesheet';
                Image = Undo;
                //Promoted = true;

                trigger OnAction();
                var
                    TestJobJnlLine: Record "Job Journal Line";
                begin
                    TestJobJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    TestJobJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");

                    IF TestJobJnlLine.FIND('-') = FALSE THEN
                        ERROR(ERRORNOTHINGTOUNSUBMIT);

                    TestJobJnlLine.SETRANGE(Approved, TRUE);

                    IF TestJobJnlLine.FINDSET = TRUE THEN
                        ERROR(ERRORCANNOTUNSUBMIT, TestJobJnlLine."Document No.");

                    IF CONFIRM(CONFIRMUNSUBMITTIMESHEET, TRUE, TestJobJnlLine."Document No.") = TRUE THEN BEGIN
                        TestJobJnlLine.SETRANGE(Approved);
                        TestJobJnlLine.FIND('-');
                        REPEAT
                            TestJobJnlLine.Submitted := FALSE;
                            TestJobJnlLine.MODIFY;
                        UNTIL TestJobJnlLine.NEXT = 0;

                        MESSAGE(MESSAGETIMESHEETUNSUBMITTED, TestJobJnlLine."Document No.");
                    END;
                end;
            }
            action("Approve Timesheet")
            {
                Caption = 'Approve Timesheet';
                Image = Approve;

                trigger OnAction();
                var
                    TestJobJnlLine: Record "Job Journal Line";
                begin
                    TestJobJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    TestJobJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");

                    IF TestJobJnlLine.FIND('-') = FALSE THEN
                        ERROR(ERRORNOTHINGTOAPPROVE);

                    TestJobJnlLine.SETRANGE(Submitted, FALSE);

                    IF TestJobJnlLine.FIND('-') = TRUE THEN
                        ERROR(ERRORCANNOTAPPROVE, TestJobJnlLine."Document No.");

                    IF CONFIRM(CONFIRMAPPROVETIMESHEET, TRUE, TestJobJnlLine."Document No.") = TRUE THEN BEGIN
                        TestJobJnlLine.SETRANGE(Submitted);
                        TestJobJnlLine.FIND('-');
                        REPEAT
                            TestJobJnlLine.Approved := TRUE;
                            TestJobJnlLine.MODIFY;
                        UNTIL TestJobJnlLine.NEXT = 0;

                        MESSAGE(MESSAGETIMESHEETAPPROVED, TestJobJnlLine."Document No.");
                    END;
                end;
            }
        }

        addafter(SuggestLinesFromTimeSheets)
        {
            action("Retreive Timesheet History")
            {
                Caption = 'Retreive Timesheet History';
                Image = PostedTimeSheet;
                //Promoted = true;
                //PromotedCategory = ;

                trigger OnAction();
                var
                    JobLedgerEntry: Record "Job Ledger Entry";
                    TimesheetHistory: Page "Timesheet History";
                begin
                    JobLedgerEntry.SETRANGE("No.", UserSetup."Linked Resource No.");
                    JobLedgerEntry.SETRANGE("Entry Type", JobLedgerEntry."Entry Type"::Usage);
                    TimesheetHistory.SETTABLEVIEW(JobLedgerEntry);
                    TimesheetHistory.RUNMODAL;
                end;
            }
            action("Timesheet Summary")
            {
                Caption = 'Timesheet Summary';
                Image = Timesheet;
                //Promoted = true;

                trigger OnAction();
                var
                    TimesheetSummary: report "Timesheet Summary";
                begin
                    TimesheetSummary.SETTABLEVIEW(Rec);
                    TimesheetSummary.RUN;
                end;
            }
        }
        modify("P&ost")
        {
            trigger OnBeforeAction();
            var
                TestJobJnlLine: Record "Job Journal Line";
            begin
                TestJobJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                TestJobJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                TestJobJnlLine.SETRANGE(Approved, FALSE);

                IF TestJobJnlLine.FINDSET = TRUE THEN
                    ERROR(ERRORENTRIESNOTAPPROVED, TestJobJnlLine."Document No.");

            end;
        }
    }

    trigger OnOpenPage();
    begin
        // Retrieve the current user's User Setup information, including the linked resource no.
        UserSetup.GET(USERID);
    end;

    trigger OnAfterGetRecord();
    begin
        // Refresh Billable counters
        RefreshBillableStatistics;
    end;

    trigger OnAfterGetCurrRecord();
    begin
        // Refresh Billable counters
        RefreshBillableStatistics;
    end;

    var
        JobJournalLine2: Record "Job Journal Line";
        UserSetup: Record "User Setup";
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
        ERRORNOTHINGTOAPPROVE: TextConst ENU = 'There is nothing to approve.';
        CONFIRMAPPROVETIMESHEET: TextConst ENU = 'Are you sure you want to approve Timesheet %1?';
        ERRORCANNOTAPPROVE: TextConst ENU = 'You cannot approve Timesheet %1 because there are unsubmitted time entries.';
        MESSAGETIMESHEETAPPROVED: TextConst ENU = 'Timesheet %1 has been approved.';


    procedure RefreshBillableStatistics();
    begin
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
    end;
}