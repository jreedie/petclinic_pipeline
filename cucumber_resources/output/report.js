$(document).ready(function() {var formatter = new CucumberHTML.DOMFormatter($('.cucumber-report'));formatter.uri("cuketest/applicationHomepage.feature");
formatter.feature({
  "comments": [
    {
      "line": 1,
      "value": "# language: en"
    }
  ],
  "line": 2,
  "name": "Loads the application homepage",
  "description": "",
  "id": "loads-the-application-homepage",
  "keyword": "Feature"
});
formatter.before({
  "duration": 4588338356,
  "status": "passed"
});
formatter.scenario({
  "line": 5,
  "name": "The user goes to the homepage",
  "description": "",
  "id": "loads-the-application-homepage;the-user-goes-to-the-homepage",
  "type": "scenario",
  "keyword": "Scenario",
  "tags": [
    {
      "line": 4,
      "name": "@important"
    }
  ]
});
formatter.step({
  "line": 6,
  "name": "Open Firefox and launch the application",
  "keyword": "Given "
});
formatter.step({
  "line": 7,
  "name": "The server responds with the homepage",
  "keyword": "Then "
});
formatter.match({
  "location": "CuketestSteps.groovy:19"
});
formatter.result({
  "duration": 1214062712,
  "status": "passed"
});
formatter.match({
  "location": "CuketestSteps.groovy:24"
});
formatter.result({
  "duration": 106416099,
  "status": "passed"
});
formatter.after({
  "duration": 1009315699,
  "status": "passed"
});
});