/*
 * generated by Xtext 2.10.0
 */
package org.boomslang.dsl.mapping


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class MappingStandaloneSetup extends MappingStandaloneSetupGenerated {

	def static void doSetup() {
		new MappingStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}
