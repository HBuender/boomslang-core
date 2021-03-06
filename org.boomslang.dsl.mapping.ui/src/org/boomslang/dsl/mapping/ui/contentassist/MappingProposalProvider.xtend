/*
 * generated by Xtext 2.10.0
 */
package org.boomslang.dsl.mapping.ui.contentassist

import org.boomslang.core.contentassist.CoreProposalProvider 
import org.boomslang.dsl.mapping.mapping.BMapping
import org.boomslang.dsl.mapping.mapping.BWidgetMapping
import org.boomslang.dsl.mapping.services.MappingGrammarAccess
import com.google.inject.Inject
import com.wireframesketcher.model.Combo
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.Assignment
import org.eclipse.xtext.CrossReference
import org.eclipse.xtext.GrammarUtil
import org.eclipse.xtext.Group
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor

import static extension org.eclipse.xtext.EcoreUtil2.*

/**
 * see http://www.eclipse.org/Xtext/documentation.html#contentAssist on how to customize content assistant
 */
class MappingProposalProvider extends AbstractMappingProposalProvider {

	@Inject extension IQualifiedNameProvider
	
	@Inject extension MappingGrammarAccess
	
	@Inject extension CoreProposalProvider

//	override completeBMapping_BWidgetMapping(EObject model, Assignment assignment, ContentAssistContext context,
//		ICompletionProposalAcceptor acceptor) {
//	}
//

    override completeBMappingPackage_Name(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
        val packageName = model.completeBPackage_Name()
        acceptor.accept(createCompletionProposal(packageName,packageName, null, context))
    }
	override complete_BWidgetMapping(EObject model, RuleCall ruleCall, ContentAssistContext context,
		ICompletionProposalAcceptor acceptor) {
		    println("asd")
	}

	override public void completeBWidgetMapping_Widget(EObject model, Assignment assignment,
		ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		addProposalsForWidget(model, assignment, context, acceptor)
	}
	
	
	override complete_ComboButtonLocator(EObject model, RuleCall ruleCall, ContentAssistContext context, ICompletionProposalAcceptor acceptor){
        if(isComboMapping(model)){
           comboButtonLocatorAccess.group.createKeywordProposal(context, acceptor)
        }
    }
    
    override complete_ComboTableLocator(EObject model, RuleCall ruleCall, ContentAssistContext context, ICompletionProposalAcceptor acceptor){
        if(isComboMapping(model)){
            comboTableLocatorAccess.group.createKeywordProposal(context,acceptor)
        }
    }
    
    def private isComboMapping(EObject model){
        switch model{
            BWidgetMapping: return (model.widget instanceof Combo)
        }
    }

	def addProposalsForWidget(EObject model, Assignment assignment, ContentAssistContext context,
		ICompletionProposalAcceptor acceptor) {
		val QualifiedName prefixQName = model.getContainerOfType(BMapping)?.screen.fullyQualifiedName

		if (prefixQName == null || prefixQName.empty) {
			return

		// Xtext default
		// lookupCrossReference(assignment.getTerminal()as CrossReference, context, acceptor)
		}

		val widgetTypeERef = GrammarUtil.getReference(assignment.getTerminal() as CrossReference)

		val IScope scope = scopeProvider.getScope(model, widgetTypeERef)
		for (IEObjectDescription description : scope.allElements) {
			val qname = description.qualifiedName

			if (qname.startsWith(prefixQName) && qname != prefixQName) {
				val shortName = qualifiedNameConverter.toString(qname.skipFirst(prefixQName.segmentCount))
				acceptor.accept(createCompletionProposal(shortName, context))
			}
		}

	}
	
	 /** 
     * For a given group, filters the keywords and joins them.
     * @param group the group to use for the proposal, example: 
     * myGrammarRuleAccess.getGroup()
     * 
     * @param withSpaceBetweenWords - set this to true if the keywords should be joined 
     * with a 'space'as separator, otherwise they will be just concatenated
     * 
     * @return the proposal, example: "I want to" for the grammar rule
     * 
     * MyGrammarDatatypeRule:
     * 'I' 'want' 'to'
     */
    def createKeywordProposal(Group group, ContentAssistContext context, ICompletionProposalAcceptor acceptor,
        boolean withSpaceBetweenWords) {
        if (group == null) {
            return null
        }
        val joinChar = if (withSpaceBetweenWords) {
                " "
            } else {
                ""
            }
        val proposalString = group.elements.filter(Keyword).map[value].join(joinChar) + " "
        acceptor.accept(createCompletionProposal(proposalString, proposalString, null, context))
    }

    def createKeywordProposal(Group group, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
        createKeywordProposal(group, context, acceptor, true)
    }

}
