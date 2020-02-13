/**
*   Documentation Section
*       GRALE01 - 01/08/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*               - Added fields "Bank Communication", "Check Date Format", and "Check Date Separator" according to definition from NAV 2009
*/
tableextension 50115 tXVendor extends Vendor
{
    fields
    {
        field(50000; "Bank Communication"; Option)
        {
            Caption = 'Bank Communication';
            FieldClass = Normal;
            OptionMembers = "E English","F French","S Spanish";
            OptionCaption = 'E English,F French,S Spanisht';
        }

        field(50001; "Check Date Format"; Option)
        {
            Caption = 'Check Date Format';
            FieldClass = Normal;
            OptionMembers = " ","MM DD YYYY","DD MM YYYY","YYYY MM DD";
            OptionCaption = ' ,MM DD YYYY,DD MM YYYY,YYYY MM DD';
        }

        field(50002; "Check Date Separator"; Option)
        {
            Caption = 'Check Date Separator';
            FieldClass = Normal;
            OptionMembers = " ","-",".","/";
            OptionCaption = ' ,-,.,/';
        }

    }
}