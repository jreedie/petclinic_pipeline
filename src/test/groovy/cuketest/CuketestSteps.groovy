package cuketest


this.metaClass.mixin(cucumber.api.groovy.Hooks)
this.metaClass.mixin(cucumber.api.groovy.EN)

//import org.openqa.selenium.firefox.FirefoxDriver


Given(~"Open Firefox and launch the application") {->
	assert(1 == 1)
}
