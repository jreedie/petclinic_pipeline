package cuketest


this.metaClass.mixin(cucumber.api.groovy.Hooks)
this.metaClass.mixin(cucumber.api.groovy.EN)

import static org.junit.Assert.*;

import org.openqa.selenium.firefox.FirefoxDriver

FirefoxDriver driver;

Before("@browser"){
	System.setProperty("webdriver.gecko.driver", "cucumber_resources/src/test/resources/geckodriver");
	driver = new FirefoxDriver();
}


Given(~"Open Firefox and launch the application") {->
	driver.get("http://localhost:8080/")
}


Then(~"The server responds with the homepage") {->
	String actualTitle = driver.getTitle();
	String expectedTitle = "PetClinic :: a Spring Framework demonstration";
	assertEquals(expectedTitle,actualTitle);
}

After("@browser") {
	driver.close();
}