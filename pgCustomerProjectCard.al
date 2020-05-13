/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created page according to definition from NAV 2009.
*
*       GRALE02 - 05/13/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Added ApplicationArea property to fields and actions
*/

page 50104 "Customer Project Card"
{
    SourceTable = Customer;
    PromotedActionCategories = 'New,Process,Report,Project';

    layout
    {
        area(Content)
        {
            field("No."; "No.")
            {
                ApplicationArea = All; //GRALE02 - Add
            }
            field(Name; Name)
            {
                ApplicationArea = All; //GRALE02 - Add
            }

            part(ReleaseVersionSubform; "Release Version Subform")
            {
                ApplicationArea = All; //GRALE02 - Add
                SubPageLink = "Customer No." = field("No.");
            }

            part(CustomerLoginsSubform; "Customer Logins Subform")
            {
                ApplicationArea = All; //GRALE02 - Add
                SubPageLink = "Customer No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Project)
            {
                ShortcutKey = F5;
                CaptionML = ENU = 'List';
                Image = List;
                RunPageOnRec = true;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = All; //GRALE02 - Add

                trigger OnAction();
                var
                    CustomerProjectList: Page "Customer Project List";
                begin
                    CustomerProjectList.LOOKUPMODE := TRUE;
                    CustomerProjectList.SETTABLEVIEW(Rec);

                    IF CustomerProjectList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        CustomerProjectList.GETRECORD(Rec);
                        CurrPage.UPDATE(FALSE);
                    end;
                end;
            }

            action("Create Patch Tag from Selected Release")
            {
                Caption = 'Create Patch Tag from Selected Release';
                Image = Process;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = All; //GRALE02 - Add

                trigger OnAction();
                var
                    ReleaseVersion: Record "Release Version";
                    ReleaseVersionPatch: Record "Release Version";
                    ExistingPatchFound: Boolean;
                    LastPatchNo: Text[30];
                begin
                    CurrPage.ReleaseVersionSubform.Page.GETRECORD(ReleaseVersion);

                    IF ReleaseVersion.Patch = FALSE THEN BEGIN
                        ReleaseVersionPatch.SETRANGE("Customer No.", ReleaseVersion."Customer No.");
                        ReleaseVersionPatch.SETFILTER("Version Tag No.", '%1', ReleaseVersion."Version Tag No." + '.*');

                        IF ReleaseVersionPatch.FINDLAST = TRUE THEN BEGIN
                            ExistingPatchFound := TRUE;
                            LastPatchNo := ReleaseVersionPatch."Version Tag No.";
                        END;

                        ReleaseVersionPatch.INIT;
                        ReleaseVersionPatch."Customer No." := ReleaseVersion."Customer No.";

                        IF ExistingPatchFound = TRUE THEN
                            ReleaseVersionPatch."Version Tag No." := INCSTR(LastPatchNo)
                        ELSE
                            ReleaseVersionPatch."Version Tag No." := ReleaseVersion."Version Tag No." + '.01';

                        ReleaseVersionPatch.Patch := TRUE;
                        ReleaseVersionPatch.INSERT;
                    END
                    ELSE
                        ERROR(ERROR_NOTRELEASE);
                end;
            }

        }

    }

    VAR
        ERROR_NOTRELEASE: TextConst ENU = 'You can only create a Patch Tag from a Release Tag';
}