import "../main.dart" show handleRequest, initAPIs;
import "package:appengine/appengine.dart" show runAppEngine;
import "dart:io";
import "dart:convert" show JSON;

main() async {
	File vars = new File("../config.json");
	String v = await vars.readAsString();
	Map<String, dynamic> varMap = JSON.decode(v);
	initAPIs(varMap["TBA_KEY"], varMap["SLACK_KEY"], varMap["SLACK_VERIFICATION_TOKEN"]);

	await runAppEngine(handleRequest);
}