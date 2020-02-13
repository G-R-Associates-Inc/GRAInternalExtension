/**
*   Documentation Section
*       GRALE01 - 01/16/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created xmlport according to definition from NAV 2009 (Dataport 50000).
*/
xmlport 50100 "Import 60 Absolute Info"
{
    Caption = 'Import 60 Absolute Info';
    Direction = Import;
    Encoding = UTF16;
    FormatEvaluate = Xml;

    schema
    {
        textelement(Root)
        {
            tableelement(AbsoluteEmailInfo; "60 Absolute E-Mail Info")
            {
                fieldelement(SuiteNo; AbsoluteEmailInfo."Suite No.")
                {

                }

                fieldelement(OwnerName; AbsoluteEmailInfo."Owner Name")
                {

                }

                fieldelement(EmailAddress; AbsoluteEmailInfo."E-Mail Address")
                {

                }

                fieldelement(EmailSent; AbsoluteEmailInfo."E-Mail Sent")
                {

                }
            }
        }
    }
}