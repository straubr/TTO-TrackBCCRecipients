#!/usr/bin/perl

# This module is triggered by a generic agent and will:
# - Read the dynamic field "900IncidentManagementBCCRecipients"
# - Append a new article (note-internal, sender_type == system) and add the df-value as body

package GAModules::TrackBCCRecipients;

use strict;
use warnings;
use utf8;
use Kernel::System::VariableCheck qw(:all);

use Kernel::System::ObjectManager;
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'TTO-TrackBCCRecipients',
    },
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Ticket = $TicketObject->TicketGet(
       TicketID      => $Param{TicketID},
       DynamicFields => 1,
       UserID        => 1,
    );

    return unless $Ticket{DynamicField_900IncidentManagementBCCRecipients};

    my $Body = "Die Mail aus dem vorhergehenden Artikel wurde an folgende BCC-Adressen verschickt:<br /><br />";
    $Body .= $Ticket{DynamicField_900IncidentManagementBCCRecipients};

    my $ArticleID = $TicketObject->ArticleCreate(
        TicketID         => $Param{TicketID},
        ArticleType      => 'note-internal',
        SenderType       => 'system',
        Subject          => "Info: Liste der BCC Empfänger",
        Body             => $Body,
        From             => 'root@localhost',
        Charset          => 'UTF8',
        MimeType         => 'text/html',
        HistoryType      => 'AddNote',
        HistoryComment   => 'Automated note - Track BCC recipients',
        UserID           => 1,
    );

}

1;
