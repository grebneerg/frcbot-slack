import 'Slack.dart';
import 'dart:async';
import 'dart:io';
import './TBA.dart';

Future main(List<String> args) async {
    TBA tba = new TBA(Platform.environment["TBA_KEY"]);

	Slack sl = new Slack(Platform.environment["SLACK_KEY"]);

	Button b = new Button("name", "text", "value", confirm: new Confirm("text", "title", "ok_text", "dismiss_text"));
	Attachment a = new Attachment("fallback", text: "text", pretext: "pretext", actions: [b], color: "#b21818", callback_id: "callback_id");
	Message m = new Message(attachments: [a]);
	print(await sl.postMessage("#general", m));
}

Message formatTeamInfo(Map<String, dynamic> info) {

	String year = new DateTime.now().year.toString();

	// new Attachment("fallback");
	String title = "Team ${info["team_number"]}: ${info["nickname"]}";

	String text = "";
	text += info["state_prov"] != "" ? "*Based in:* ${info["state_prov"]}\n" : "";
	text += info["motto"] != "" ? "*Motto:* ${info["motto"]}\n" : "";
	text += info["home_championship"].contains(year) ? "*Home chamionship:* ${info["home_championship"][year]}\n" : "";

	Attachment a = new Attachment("$title\n$text", text: text, title: title);

	return new Message(attachments: [a]);
}
