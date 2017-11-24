import 'Slack.dart';
import 'dart:async';
import 'dart:io';
import './TBA.dart';

TBA tba;
Slack sl;

Future main(List<String> args) async {
    tba = new TBA(Platform.environment["TBA_KEY"]);
	sl = new Slack(Platform.environment["SLACK_KEY"]);

	Button b = new Button("name", "text", "value", confirm: new Confirm("text", "title", "ok_text", "dismiss_text"));
	Attachment a = new Attachment("fallback", text: "text", pretext: "pretext", actions: [b], color: "#b21818", callback_id: "callback_id");
	// Message m = new Message(attachments: [a]);

	Map<String, dynamic> info = await tba.getTeam(639);
	Message m = new Message(attachments: [formatTeamInfo(info)]);
	print(await sl.postMessage("#general", m));
}

Attachment formatTeamInfo(Map<String, dynamic> info) {
	String title = "Team ${info["team_number"]}: ${info["nickname"]}";

	String text = "";
	text += info["state_prov"] != "" ? "*Based in:* ${info["state_prov"]}\n" : "";
	text += info["motto"] != "" ? "*Motto:* ${info["motto"]}\n" : "";
	text += info["rookie_year"] != "" ? "*Rookie Year:* ${info["rookie_year"]}\n" : "";
	text += info["home_championship"].containsKey("2017") ? "*Home chamionship 2017:* ${info["home_championship"]["2017"]}\n" : "";
	text += info["home_championship"].containsKey("2018") ? "*Home chamionship 2018+:* ${info["home_championship"]["2018"]}\n" : "";
	text += "<https://www.thebluealliance.com/team/${info["team_number"]}|View more on The Blue Alliance>";

	Attachment a = new Attachment("$title\n$text", text: text, title: title, title_link: info["website"], color: "#b21818");

	return a;
}
