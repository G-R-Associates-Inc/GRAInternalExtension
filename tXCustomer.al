/**
*   Documentation Section
*       GRALE01 - 01/08/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*               - Added fields "Bank Communication", "Check Date Format", and "Check Date Separator" according to definition from NAV 2009
*/
tableextension 50114 tXCustomer extends Customer
{
    fields
    {

        field(50000; "Components on Sales Orders"; Option)
        {
            Caption = 'Components on Sales Orders';
            FieldClass = Normal;
            OptionMembers = " ",Show,"Do Not Show";
            OptionCaption = ' ,Show,Do Not Show';
            InitValue = Show;
        }

        field(50001; "Components on Shipments"; Option)
        {
            Caption = 'Components on Shipments';
            FieldClass = Normal;
            OptionMembers = " ",Show,"Do Not Show";
            OptionCaption = ' ,Show,Do Not Show';
            InitValue = Show;
        }

        field(50002; "Components on Invoices"; Option)
        {
            Caption = 'Components on Invoices';
            FieldClass = Normal;
            OptionMembers = " ",Show,"Do Not Show";
            OptionCaption = ' ,Show,Do Not Show';
            InitValue = Show;
        }

    }
}