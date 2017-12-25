import "../main.dart" show handleRequest, initAPIs;
import "package:appengine/appengine.dart" show runAppEngine;

main() async {
	initAPIs(Platform.environment["TBA_KEY"], Platform.environment["SLACK_KEY"], Platform.environment["SLACK_VERIFICATION_TOKEN"]);

	await runAppEngine(handleRequest);
}