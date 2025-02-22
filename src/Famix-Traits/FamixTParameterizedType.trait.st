"
FamixTParameterizedType represents a type with arguments. So, it is an instantiation for the use of FamixTParameterizableClass. It can appear as a type of an attribute, a type of a local variable, a parameter of a method, a return of a method, etc.
Example:

...
public Map<String,Collection> anAttribute;
...

Where Map<String,Collection> is the FamixTParameterizedType of anAttribute. String and Collection are arguments. Map is the parameterizableClass.
"
Trait {
	#name : #FamixTParameterizedType,
	#instVars : [
		'#parameterizableClass => FMOne type: #FamixTWithParameterizedTypes opposite: #parameterizedTypes'
	],
	#category : #'Famix-Traits-ParameterizedType'
}

{ #category : #meta }
FamixTParameterizedType classSide >> annotation [

	<FMClass: #TParameterizedType super: #Object>
	<package: #'Famix-Traits'>
	<generated>
	^self
]

{ #category : #accessing }
FamixTParameterizedType >> parameterizableClass [
	"Relation named: #parameterizableClass type: #FamixTWithParameterizedTypes opposite: #parameterizedTypes"

	<generated>
	<FMComment: 'Base type of this parameterized type.'>
	^ parameterizableClass
]

{ #category : #accessing }
FamixTParameterizedType >> parameterizableClass: anObject [

	parameterizableClass := anObject.
	self resetMooseName.
	

]
