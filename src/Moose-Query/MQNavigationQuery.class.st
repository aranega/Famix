"
Description
-------------------

I am an object representing a navigations query of MooseQuery.

I allow one to to know:
- The list of associations representing a dependency of an entity 
- The entities that are dependencies of an entity
- If an entity has dependencies

I can be configured with multiple parameters:
- The kind of dependencies to select (All? One? Multiple?)
- The direction of the dependency (Incoming or outgoing)
- If the query should look only in the entity to query or should also check the dependencies on its children

Examples
-------------------

For examples check the class comment of MooseQuery.

Internal Representation and Key Implementation Points.
-------------------

    Instance Variables
	associationSelectionStrategy:				<anAssociationSelectionStrategy>		A strategy used to select the kind of associations we want to select with the query.
	directionStrategy:								<aDirectionStrategy> 						A strategy responsible of the behavior depending on the direction of the association.
	resultKindStrategy:							<aResultKindStrategy>						A strategy to select what kind of result we want to return to the user.
	shouldCollectChildrenDependencies:		<aBoolean>									If true, we collect the dependencies of the entity and its children. If false we do not check the children.

"
Class {
	#name : #MQNavigationQuery,
	#superclass : #MQAbstractQuery,
	#instVars : [
		'directionStrategy',
		'resultKindStrategy',
		'associationSelectionStrategy',
		'shouldCollectChildrenDependencies'
	],
	#category : #'Moose-Query-Navigating'
}

{ #category : #'instance creation' }
MQNavigationQuery class >> direction: aSymbol [
	^ self directionStrategy: (MQNavigationDirectionStrategy fromSymbol: aSymbol)
]

{ #category : #'instance creation' }
MQNavigationQuery class >> directionStrategy: aStrategy [
	^ self new
		directionStrategy: aStrategy;
		yourself
]

{ #category : #accessing }
MQNavigationQuery >> associationSelectionStrategy [
	^ associationSelectionStrategy
]

{ #category : #accessing }
MQNavigationQuery >> associationSelectionStrategy: anObject [
	associationSelectionStrategy := anObject
]

{ #category : #DSL }
MQNavigationQuery >> dependencies [
	associationSelectionStrategy := MQNavigationAllAssociationsStrategy new.
	^ self execute
]

{ #category : #DSL }
MQNavigationQuery >> dependenciesOfAnyType: aCollectionOfTypes [
	associationSelectionStrategy := MQNavigationSpecificAssociationsStrategy associations: aCollectionOfTypes.
	^ self execute
]

{ #category : #DSL }
MQNavigationQuery >> dependenciesOfType: anAssociation [
	associationSelectionStrategy := MQNavigationSpecificAssociationStrategy association: anAssociation.
	^ self execute
]

{ #category : #accessing }
MQNavigationQuery >> directionStrategy [
	^ directionStrategy
]

{ #category : #accessing }
MQNavigationQuery >> directionStrategy: anObject [
	directionStrategy := anObject
]

{ #category : #execution }
MQNavigationQuery >> execute [
	^ resultKindStrategy execute: self
]

{ #category : #execution }
MQNavigationQuery >> executeHasQuery [
	^ self hasFor: receiver
]

{ #category : #execution }
MQNavigationQuery >> executeQueryForQueryResult: aQueryResultClass [
	result := aQueryResultClass on: receiver.

	self queryFor: receiver.

	^ result
]

{ #category : #DSL }
MQNavigationQuery >> has [
	^ self resultKindStrategy: MQNavigationHasDependencyBooleanKindStrategy
]

{ #category : #execution }
MQNavigationQuery >> hasFor: anEntity [
	"I know that we could use #do: here, but this algo takes too long on big model, so this is a speed up while the sista vm is not ready for production"

	| selectors |
	(self hasLocalFor: anEntity) ifTrue: [ ^ true ].
	
	shouldCollectChildrenDependencies ifFalse: [ ^ false ].
	
	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."
	1 to: (selectors := anEntity childrenSelectors) size do: [ :index | 
		(anEntity perform: (selectors at: index))
			ifNotNil: [ :children | 
				| coll |
				1 to: (coll := children asCollection) size do: [ :i | (self hasFor: (coll at: i)) ifTrue: [ ^ true ] ] ] ].
	^ false
]

{ #category : #execution }
MQNavigationQuery >> hasLocalFor: anEntity [
	"The goal here is to get all the entity's direct associations of the class in parameter. This will not check the associations of the entity's children."

	"Note: Maybe adding a guard to check if the entity can have associations of this class could improve the perf. Currently it is not the case because there is not enough association. Maybe it could be the case in the futur, like with a PostgreSQL model."

	| properties |
	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."
	1 to: (properties := directionStrategy msePropertiesOf: anEntity) size do: [ :ind | 
		(anEntity perform: (properties at: ind) name)
			ifNotNil: [ :coll | (associationSelectionStrategy selectAssociationsIn: coll asCollection) ifNotEmpty: [ ^ true ] ] ].
	^ false
]

{ #category : #DSL }
MQNavigationQuery >> incoming [
	^ self directionStrategy: MQNavigationIncomingDirectionStrategy
]

{ #category : #initialization }
MQNavigationQuery >> initialize [
	super initialize.
	resultKindStrategy := MQNavigationAssociationKindStrategy.
	shouldCollectChildrenDependencies := true
]

{ #category : #DSL }
MQNavigationQuery >> local [
	shouldCollectChildrenDependencies := false
]

{ #category : #DSL }
MQNavigationQuery >> objects [
	resultKindStrategy := MQNavigationOppositeKindStrategy
]

{ #category : #DSL }
MQNavigationQuery >> outgoing [
	^ self directionStrategy: MQNavigationOutgoingDirectionStrategy
]

{ #category : #execution }
MQNavigationQuery >> queryFor: anEntity [
	"collects in aCollection all entities on the opposite side of associations with self
	 Opposite side depends on self strategy (incoming/outgoing)
	
	First collects entities from local (not inherited) properties
	Then get children entities of self and applies recurvively on them"

	| selectors |
	self queryLocalFor: anEntity.

	shouldCollectChildrenDependencies ifFalse: [ ^ self ].

	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."
	1 to: (selectors := anEntity childrenSelectors) size do: [ :index | 
		(anEntity perform: (selectors at: index))
			ifNotNil: [ :children | 
				| coll |
				1 to: (coll := children asCollection) size do: [ :i | self queryFor: (coll at: i) ] ] ]
]

{ #category : #execution }
MQNavigationQuery >> queryLocalFor: anEntity [

	"The goal here is to get all the entity's direct associations of the class in parameter. This will not check the associations of the entity's children."

	"Note: Maybe adding a guard to check if the entity can have associations of this class could improve the perf. Currently it is not the case because there is not enough association. Maybe it could be the case in the futur, like with a PostgreSQL model."

	| properties |
	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."
	1 to:
		(properties := directionStrategy msePropertiesOf: anEntity) size do: [ 
		:ind | 
		(anEntity perform: (properties at: ind) name) ifNotNil: [ :coll | 
			result addAll: (resultKindStrategy
					 collectResultFrom:
					 (associationSelectionStrategy selectAssociationsIn:
						  coll asCollection)
					 query: self) ] ]
]

{ #category : #accessing }
MQNavigationQuery >> resultKindStrategy [
	^ resultKindStrategy
]

{ #category : #accessing }
MQNavigationQuery >> resultKindStrategy: anObject [
	resultKindStrategy := anObject
]

{ #category : #accessing }
MQNavigationQuery >> shouldCollectChildrenDependencies [
	^ shouldCollectChildrenDependencies
]

{ #category : #accessing }
MQNavigationQuery >> shouldCollectChildrenDependencies: anObject [
	shouldCollectChildrenDependencies := anObject
]
