package cuketest;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
	features = "src/test/resources/cuketest",
	glue = "src/test/groovy",
	plugin = "json:target/cucumber_output.json"
	)
public class RunCukesTest {
	// public static void main(String[] args) throws Throwable {
 //    //String[] arguments = {"--glue", "src/test/groovy", "src/test/resources"};
 //    cucumber.api.cli.Main.main(args);
	// }
}


