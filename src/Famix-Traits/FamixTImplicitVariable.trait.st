"
FamixTImplicitVariable represents a variable defined by the compiler in a context, such as self, super, thisContext.
"
Trait {
	#name : #FamixTImplicitVariable,
	#instVars : [
		'#parentBehaviouralEntity => FMOne type: #FamixTWithImplicitVariables opposite: #implicitVariables'
	],
	#traits : 'FamixTStructuralEntity',
	#classTraits : 'FamixTStructuralEntity classTrait',
	#category : #'Famix-Traits-ImplicitVariable'
}

{ #category : #meta }
FamixTImplicitVariable classSide >> annotation [

	<FMClass: #TImplicitVariable super: #Object>
	<package: #'Famix-Traits'>
	<generated>
	^self
]

{ #category : #testing }
FamixTImplicitVariable >> isImplicitVariable [

	<generated>
	^ true
]

{ #category : #accessing }
FamixTImplicitVariable >> parentBehaviouralEntity [
	"Relation named: #parentBehaviouralEntity type: #FamixTWithImplicitVariables opposite: #implicitVariables"

	<generated>
	<FMComment: 'The behaviour containing this implicit variable. belongsTo implementation'>
	<container>
	^ parentBehaviouralEntity
]

{ #category : #accessing }
FamixTImplicitVariable >> parentBehaviouralEntity: anObject [

	parentBehaviouralEntity := anObject.
	self resetMooseName.
	

]

{ #category : #navigation }
FamixTImplicitVariable >> parentBehaviouralEntityGroup [
	<generated>
	<navigation: 'ParentBehaviouralEntity'>
	^ MooseSpecializedGroup with: self parentBehaviouralEntity
]
