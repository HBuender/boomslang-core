package org.boomslang.dsl.feature.services

import org.boomslang.dsl.feature.feature.BAssertionComponent
import org.boomslang.dsl.feature.feature.BCommandComponent
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.EcoreUtil2

class BActionUtil {
	def isCommandActionContext(EObject element) {
		EcoreUtil2.getContainerOfType(element, BCommandComponent) != null
	}

	def isAssertionActionContext(EObject element) {
		EcoreUtil2.getContainerOfType(element, BAssertionComponent) != null
	}
}
