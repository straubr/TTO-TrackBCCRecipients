package Kernel::Output::HTML::FilterElementPost::TrackBCCRecipients;

use strict;
use warnings;

#use JSON;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = \%Param;
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # return if not in AgentTicketEmail (should not happen)
    return if $Param{TemplateFile} !~ /^(AgentTicketEmail)/;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $HookString = "<!--HookStartRichText-->";
    my $JavaScript = << "EOF";

  \$('#DynamicField_TrackBCCRecipients').parent().addClass( 'Hidden' );
  \$('#LabelDynamicField_TrackBCCRecipients').parent().addClass( 'Hidden' );

  \$('#submitRichText').bind('click', function () {
      var allRecipients = '';
      \$('[id^=BccCustomerKey_]').each(function(){
        allRecipients = allRecipients + \$(this).val() + ';';
      });
      
      \$('#DynamicField_TrackBCCRecipients').val(allRecipients);
  });
EOF

    $LayoutObject->AddJSOnDocumentComplete (
        Code => $JavaScript,
    );

#    ${ $Param{Data} } =~ s/$HookString/$JavaScript\n$HookString/;

    return 1;
}

1;

