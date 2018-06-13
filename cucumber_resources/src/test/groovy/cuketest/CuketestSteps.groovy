package cuketest


this.metaClass.mixin(cucumber.api.groovy.Hooks)
this.metaClass.mixin(cucumber.api.groovy.EN)

import static org.junit.Assert.*;

import org.openqa.selenium.htmlunit.HtmlUnitDriver

import org.springframework.samples.petclinic.model.Person

HtmlUnitDriver driver;

Person person;

Before("@browser"){
	System.setProperty("webdriver.gecko.driver", "src/test/resources/geckodriver");
	driver = new HtmlUnitDriver();
}


// Given(~"Open Firefox and launch the application") {->
// 	driver.get("http://localhost:8090/")
// }


// Then(~"The server responds with the homepage") {->
// 	String actualTitle = driver.getTitle();
// 	String expectedTitle = "PetClinic :: a Spring Framework demonstration";
// 	assertEquals(expectedTitle,actualTitle);
// }

Given(~/^Given a Person is named "([^"]*)"$/) { String arg1 ->
    // Write code here that turns the phrase above into concrete actions
    person = new Person();
    person.setFirstName(arg1);
}

Then(~/^Their name is recorded as "([^"]*)"$/) { String arg1 ->
    // Write code here that turns the phrase above into concrete actions
    assertEquals(arg1, person.getFirstName());
}



After("@browser") {
	driver.close();
}