###
# Include the modules that we need. This is added to the first text area in
# the Fastmail interface.
#
require ["variables", "fileinto"];

### 
# Define our mail folders.
#
set "newsletterFolder" "INBOX.INBOX.Newsletters";
set "notificationsFolder" "INBOX.INBOX.Notifications";

############################################################################
# Categorisation Rules
############################################################################

# Github: Catch any notifications.
if header :contains "X-GitHub-Recipient" "" {
    fileinto "${notificationsFolder}";
    stop;
}

if anyof(
    # If the List-ID header is present, and we haven't categorised it anywhere
    # else yet, then this email was probably sent from a mailing list, so mark
    # it as a newsletter.
    header :contains "List-Id" "",

    # If the List-Unsubscribe is present then that implies you subscribed to
    # something in the first place, so class it as a newsletter.
    header :contains "List-Unsubscribe" "",

    # Not a common one, but recommended by Google for bulk mail:
    # https://support.google.com/mail/answer/81126?hl=en
    header :contains "Precedence" "bulk",

    # Hubspot
    header :contains "X-HubSpot-Message-Id" "",

    # Meetup
    header :contains "X-MEETUP-MESG-ID" ""
) {
    fileinto "${newsletterFolder}";
    stop;
}

# GDPR: Mark any GDPR message as read and move to archive
if 
  anyof(
  header :contains "Subject" "gdpr",
  body :text :contains "gdpr"
  )
{
  addflag "\\Seen";
  fileinto "\\Archive";
  removeflag "\\Seen";
}
