/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created page according to definition from NAV 2009.
*       GRALE02 - 01/14/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Modified Copy Job References to the new Copy Job Page
*/

page 50107 "Job Task Worksheet"
{

    CaptionML = ENU = 'Job Task Worksheet', ESM = 'L¡neas tarea proyecto', FRC = 'Lignes de tƒche de projet', ENC = 'Job Task Worksheet';
    SourceTable = "Job Task";
    DelayedInsert = true;
    DataCaptionFields = "Job No.";
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Job Tasks,Functions';


    layout
    {
        area(Content)
        {
            field(CurrentJobNo; CurrentJobNo)
            {
                TableRelation = Job;
                Caption = 'Job No.';
                //Editable = false;


                trigger OnValidate();
                begin
                    Job.Get(CurrentJobNo);
                    JobDescription := Job.Description;
                end;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord();
                    Commit;
                    Job."No." := CurrentJobNo;
                    if Page.RUNMODAL(0, Job) = ACTION::LookupOK then begin
                        Job.GET(Job."No.");
                        CurrentJobNo := Job."No.";
                        JobDescription := Job.Description;
                        FILTERGROUP := 2;
                        SETRANGE("Job No.", CurrentJobNo);
                        FILTERGROUP := 0;
                        if Find('-') then;
                        CurrPage.Update(false);
                    end;
                end;
            }

            field(JobDescription; JobDescription)
            {
                Caption = 'Job Description';
            }
            repeater("Job Task List")
            {
                field("Job No."; "Job No.")
                {
                    Visible = false;
                }
                field("Job Task No."; "Job Task No.")
                {

                }

                field(Description; Description)
                {

                }

                field("Job Task Type"; "Job Task Type")
                {

                }

                field("WIP-Total"; "WIP-Total")
                {

                }

                field(Totaling; Totaling)
                {

                }

                field("Job Posting Group"; "Job Posting Group")
                {

                }

                field(Chargeable; Chargeable)
                {

                }
            }
        }
    }

    actions
    {

        area(Processing)
        {
            group("Job Task")
            {
                action("List")
                {
                    Caption = 'List';
                    ShortcutKey = F5;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        JobTaskList: Page "Job Task List";
                    begin

                        JobTaskList.LookupMode := true;
                        if JobTaskList.RunModal = Action::LookupOK then;
                    end;
                }

                action("Job Task Card")
                {
                    Caption = 'Job Task Card';
                    ShortcutKey = "Shift+F5";
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Job Task Card";
                    RunPageLink = "Job No." = field("Job No."), "Job Task No." = field("Job Task No.");
                }
            }
            group(Functions)
            {
                action("Copy Job Task &From")
                {
                    Image = CopyFromTask;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    //GRALE02 - Delete Start
                    //In newer NAV versions, this became a page instead of a report
                    /*trigger OnAction();
                    var
                        CopyJobTask: Report "Copy Job Task";
                    begin
                        TESTFIELD("Job Task Type", "Job Task Type"::Posting);
                        CopyJobTask.SetCopyFrom(Rec);
                        CopyJobTask.RUNMODAL;
                    end;*/
                    //GRALE02 - Delete End

                    //GRALE02 - Add Start
                    trigger OnAction();
                    var
                        CopyJobTask: Page "Copy Job Tasks";
                        Job: Record Job;
                    begin
                        Job.Get("Job No.");
                        CopyJobTask.SetFromJob(Job);
                        CopyJobTask.RUNMODAL;
                    end;
                    //GRALE02 - Add End
                }

                action("Copy Job Task &To")
                {
                    Image = CopyToTask;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    //GRALE02 - Delete Start
                    //In newer NAV versions, this became a page instead of a report
                    /*trigger OnAction();
                    var
                        CopyJobTask: Report "Copy Job Task";
                    begin
                        TESTFIELD("Job Task Type", "Job Task Type"::Posting);
                        CopyJobTask.SetCopyTo(Rec);
                        CopyJobTask.RUNMODAL;
                    end;*/
                    //GRALE02 - Delete End

                    //GRALE02 - Add Start
                    trigger OnAction();
                    var
                        CopyJobTask: Page "Copy Job Tasks";
                        Job: Record Job;
                    begin
                        Job.Get("Job No.");
                        CopyJobTask.SetToJob(Job);
                        CopyJobTask.RUNMODAL;
                    end;
                    //GRALE02 - Add End
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        IF CurrentJobNo3 <> '' THEN
            CurrentJobNo := CurrentJobNo3;
        IF NOT Job.GET(CurrentJobNo) THEN
            Job.FIND('-');
        CurrentJobNo := Job."No.";
        JobDescription := Job.Description;
        FILTERGROUP := 2;
        SETRANGE("Job No.", CurrentJobNo);
        FILTERGROUP := 0;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        ClearTempDim();
    end;

    VAR
        Job: Record Job;
        CurrentJobNo: Code[20];
        CurrentJobNo3: Code[20];
        JobDescription: Text[50];

    PROCEDURE SetJobNo(CurrentJobNo2: Code[20]);
    BEGIN
        CurrentJobNo3 := CurrentJobNo2;
    END;
}