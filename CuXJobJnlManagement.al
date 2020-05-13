/**
* This codeunit is meant to call any trigger related to JobJnlManagement Codeunit in Base NAV
*
*   Documentation Section
*       GRALE01 - 12/24/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created codeunit.
*
*       GRALE02 - 05/13/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Fix bug where Template JOB kept getting creating without checking existing records with same Name,
*               - resulting in Error.
*               - Fix Timesheet Page ID was not being set when the Template was created.
*/
codeunit 50102 CuXJobJnlManagement
{
    procedure TemplateSelectionCustom(PageID: Integer; RecurringJnl: Boolean; var JobJnlLine: Record "Job Journal Line"; var JnlSelected: Boolean)
    var
        JobJnlTemplate: Record "Job Journal Template";
    begin
        JnlSelected := true;

        JobJnlTemplate.Reset;
        JobJnlTemplate.SetRange("Page ID", PageID);
        JobJnlTemplate.SetRange(Recurring, RecurringJnl);


        // Added this section to add advanced capabilities of using two different forms for the same template
        // Page ID field remains for the job journal, while the Timesheet Page ID was added as an optional second timesheet
        IF JobJnlTemplate.IsEmpty = true then begin
            JobJnlTemplate.Reset;
            JobJnlTemplate.SetRange("Timesheet Page ID", PageID);
            JobJnlTemplate.SetRange(Recurring, RecurringJnl);
            case JobJnlTemplate.Count of
                0:
                    begin
                        JobJnlTemplate.Init;
                        JobJnlTemplate.Recurring := RecurringJnl;
                        if not RecurringJnl then begin
                            JobJnlTemplate.Name := Text000;
                            JobJnlTemplate.Description := Text001;
                        end else begin
                            JobJnlTemplate.Name := Text002;
                            JobJnlTemplate.Description := Text003;
                        end;
                        JobJnlTemplate.Validate("Page ID");
                        //GRALE02 - Add Start
                        //This line is important, otherwise the code will always execute this Case option.
                        JobJnlTemplate.Validate("Timesheet Page ID", PageID);
                        //GRALE02 - Add End

                        //GRALE02 - Change Start
                        //Added check to see if the record is already there, then simply modify it. Otherwise it was generating
                        //an exception. Especially when we were not setting TimeSheet Page ID
                        if not JobJnlTemplate.Insert then
                            JobJnlTemplate.Modify;
                        //GRALE02 - Change End
                        Commit;
                    end;
                1:
                    JobJnlTemplate.FindFirst;
                else
                    JnlSelected := PAGE.RunModal(0, JobJnlTemplate) = ACTION::LookupOK;
            end;
        end else begin
            case JobJnlTemplate.Count of
                0:
                    begin
                        JobJnlTemplate.Init;
                        JobJnlTemplate.Recurring := RecurringJnl;
                        if not RecurringJnl then begin
                            JobJnlTemplate.Name := Text000;
                            JobJnlTemplate.Description := Text001;
                        end else begin
                            JobJnlTemplate.Name := Text002;
                            JobJnlTemplate.Description := Text003;
                        end;
                        JobJnlTemplate.Validate("Page ID");
                        //GRALE02 - Change Start
                        //Added check to see if the record is already there, then simply modify it. Otherwise it was generating
                        //an exception. Especially when we were not setting TimeSheet Page ID
                        if not JobJnlTemplate.Insert then
                            JobJnlTemplate.Modify;
                        //GRALE02 - Change End
                        Commit;
                    end;
                1:
                    JobJnlTemplate.FindFirst;
                else
                    JnlSelected := PAGE.RunModal(0, JobJnlTemplate) = ACTION::LookupOK;
            end;
        end;

        if JnlSelected then begin
            JobJnlLine.FilterGroup := 2;
            JobJnlLine.SetRange("Journal Template Name", JobJnlTemplate.Name);
            JobJnlLine.FilterGroup := 0;
            if OpenFromBatch then begin
                JobJnlLine."Journal Template Name" := '';
                PAGE.Run(JobJnlTemplate."Page ID", JobJnlLine);
            end;
        end;
    end;

    procedure CreateNewBatch(TemplateName: Code[10]; BatchName: Code[10]; PostingSeries: Code[20]): Code[10]
    var
        JobJournalBatch: Record "Job Journal Batch";
    begin
        JobJournalBatch.INIT;
        JobJournalBatch.Name := BatchName;
        JobJournalBatch."Journal Template Name" := TemplateName;
        JobJournalBatch."No. Series" := PostingSeries;
        JobJournalBatch.INSERT;

        EXIT(JobJournalBatch.Name);
    end;


    procedure GetNamesWithTask(var JobJnlLine: Record "Job Journal Line"; var JobDescription: Text[50]; var AccName: Text[50]; var JobTaskDescription: Text[50]);
    var
        Job: Record Job;
        Res: Record Resource;
        Item: Record Item;
        GLAcc: Record "G/L Account";
        JobTask: Record "Job Task";
    begin
        IF (JobJnlLine."Job No." = '') OR
        (JobJnlLine."Job No." <> LastJobJnlLine."Job No.")
        THEN BEGIN
            JobDescription := '';

            IF Job.GET(JobJnlLine."Job No.") THEN BEGIN
                JobDescription := Job.Description;
            END;
        END;

        IF (JobJnlLine.Type <> LastJobJnlLine.Type) OR
        (JobJnlLine."No." <> LastJobJnlLine."No.")
        THEN BEGIN
            AccName := '';
            IF JobJnlLine."No." <> '' THEN
                CASE JobJnlLine.Type OF
                    JobJnlLine.Type::Resource:
                        IF Res.GET(JobJnlLine."No.") THEN
                            AccName := Res.Name;
                    JobJnlLine.Type::Item:
                        IF Item.GET(JobJnlLine."No.") THEN
                            AccName := Item.Description;
                    JobJnlLine.Type::"G/L Account":
                        IF GLAcc.GET(JobJnlLine."No.") THEN
                            AccName := GLAcc.Name;
                END;
        END;

        IF (JobTask."Job Task No." = '') OR (JobTask."Job No." <> LastJobTask."Job No.") THEN BEGIN
            JobTaskDescription := '';
            IF JobTask.GET(JobJnlLine."Job No.", JobJnlLine."Job Task No.") THEN
                JobTaskDescription := JobTask.Description;
        END;

        LastJobTask := JobTask;

        LastJobJnlLine := JobJnlLine;
    end;

    var
        LastJobJnlLine: Record "Job Journal Line";
        LastJobTask: Record "Job Task";
        OpenFromBatch: Boolean;
        Text000: Label 'JOB';
        Text001: Label 'Job Journal';
        Text002: Label 'RECURRING';
        Text003: Label 'Recurring Job Journal';
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';
}