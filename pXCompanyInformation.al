pageextension 50113 pXCompanyInformation extends "Company Information"
{
    layout
    {
        addafter(GLN)
        {
            field("Federal ID No."; "Federal ID No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Federal ID No.';
                Importance = Standard;

            }
        }
        addafter(BankAccountPostingGroup)
        {
            field("US Country/Region Code"; "US Country/Region Code")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'US Country/Region Code';
                Importance = Standard;

            }

            field("Canada Country/Region Code"; "Canada Country/Region Code")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Canada Country/Region Code';
                Importance = Standard;

            }

            field("Mexico Country/Region Code"; "Mexico Country/Region Code")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Mexico Country/Region Code';
                Importance = Standard;

            }
        }
    }
}