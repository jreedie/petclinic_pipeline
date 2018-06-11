package cuketest


this.metaClass.mixin(cucumber.api.groovy.Hooks)
this.metaClass.mixin(cucumber.api.groovy.EN)

import static org.junit.Assert.*;

import org.openqa.selenium.htmlunit.HtmlUnitDriver

import org.springframework.samples.petclinic.model.Person

HtmlUnitDriver driver;

Before("@browser"){
	System.setProperty("webdriver.gecko.driver", "src/test/resources/geckodriver");
	driver = new HtmlUnitDriver();
}


Given(~"Open Firefox and launch the application") {->
	driver.get("http://localhost:8090/")
}


Then(~"The server responds with the homepage") {->
	String actualTitle = driver.getTitle();
	String expectedTitle = "PetClinic :: a Spring Framework demonstration";
	assertEquals(expectedTitle,actualTitle);
}

After("@browser") {
	driver.close();
}