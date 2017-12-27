# FRCbot-slack
A slack bot that does [FRC](https://www.firstinspires.org/robotics/frc) related things.

## What does FRCbot do?

As of right now FRCbot can:
* Listen for messages including "team ####" and respond with information about that team from [The Blue Alliance](https://www.thebluealliance.com).

## How do I install FRCbot to my slack team?
At the moment, FRCbot is still in beta and is not distributed in the slack app directory. To use it, you will need to host it yourself and create an app associated with your workspace.

I have been hosting on a Heroku free plan, and passing in app specific tokens as environment variables. You will need to specify your `SLACK_KEY` (to use the slack web api), `TBA_KEY` (for The Blue Alliance api), and `SLACK_VERIFICATION_TOKEN` (to verify requests are from slack).

The app requires these permission scopes (_Note: some of these may be unused. I'm not 100% sure_):
* `channels:history`
* `channels:read`
* `channels:write`
* `chat:write:bot`
* `groups:history`
* `im:history`
* `mpim:history`

And must be subscribed to these events:
* `message.channels`
* `message.groups`
* `message.im`
* `message.mpim`

If you use FRCbot, let me know on [Twitter](https://twitter.com/thprgrmmrjck)! Please open issues with any feedback, bugs, or suggestions.

## What are your plans for FRCbot?
I want to continue to improve FRCbot and eventually distribute it on the Slack App Directory.

Things I'm working:
* Adding new features. Please feel free to open issues for any suggestions.
* Investigating the best way to distribute FRCbot.
