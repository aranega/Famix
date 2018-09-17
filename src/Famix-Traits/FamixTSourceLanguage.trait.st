"
FAMIXSourceLanguage represents the programming language in which an entity is written. It is used for dispatching entity actions for specific languages. For example, formatting a source text will be performed according to the language. A project may have multiple languages. 

A source language has a name and entities that are written in this language. 
One can create a default source language for a project by not associating any entities to it. In this case, all entities that do not have specific source langauge, belong to the default source language. One can attach entities to a sourceLanguage using addSourceEntity:.
"
Trait {
	#name : #FamixTSourceLanguage,
	#instVars : [
		'#sourcedEntities => FMMany type: #FamixTWithSourceLanguage opposite: #declaredSourceLanguage'
	],
	#category : #'Famix-Traits-SourceLanguage'
}

{ #category : #meta }
FamixTSourceLanguage classSide >> annotation [

	<MSEClass: #TSourceLanguage super: #Trait>
	<generated>
	<package: #'Famix-Traits'>
	^self
]

{ #category : #generator }
FamixTSourceLanguage classSide >> generatedSlotNames [
	<generated>
	'FamixTSourceLanguage class>>#generatedSlotNames'.
	^ #(sourcedEntities)
]

{ #category : #generator }
FamixTSourceLanguage classSide >> generatedTraitNames [
	<generated>
	^ #()
]

{ #category : #adding }
FamixTSourceLanguage >> addSourcedEntity: aSourcedEntity [
	^ self sourcedEntities add: aSourcedEntity
]

{ #category : #testing }
FamixTSourceLanguage >> isAttached [
	"Returns whether the receiver (a language) has some entities associated with it. By default, if there are no entities attached, it means that all of them are of this language."

	^ self sourcedEntities notEmpty  
]

{ #category : #accessing }
FamixTSourceLanguage >> sourcedEntities [

	<generated>
	<MSEComment: 'References to the entities saying explicitly that are written in this language.'>
	^ sourcedEntities
]

{ #category : #accessing }
FamixTSourceLanguage >> sourcedEntities: anObject [

	<generated>
	sourcedEntities value: anObject

]