Class {
	#name : #FAMIXInvocation,
	#superclass : #FAMIXEntity,
	#traits : 'FamixTHasSignature + FamixTInvocation',
	#classTraits : 'FamixTHasSignature classTrait + FamixTInvocation classTrait',
	#category : #'Famix-Compatibility-Entities-Entities'
}

{ #category : #meta }
FAMIXInvocation class >> annotation [

	<FMClass: #Invocation super: #FAMIXEntity>
	<package: #FAMIX>
	<generated>
	^self
]

{ #category : #'Famix-Implementation' }
FAMIXInvocation >> displayStringOn: aStream [
	self source ifNotNil: [ :s | s displayStringOn: aStream ].
	aStream nextPutAll: ' -> '.
	self receiver ifNotNil: [ aStream nextPutAll: self receiver name ].
	aStream nextPut: $#.
	aStream nextPutAll: self signature.
	aStream nextPutAll: ' -> '.
	self candidates size = 1 ifTrue: [ self anyCandidate displayStringOn: aStream ]
]

{ #category : #'Famix-Extensions' }
FAMIXInvocation >> getReceivingFAMIXClass [
	| tmpReceiver |
	"return the FAMIXClass of the receiver. If the receiver is a FAMIXClass, this one is returned. If it is self or super, the corresponding FAMIXClass is returned. The receiver may not be nil"
	tmpReceiver := self receiver.

	tmpReceiver isImplicitVariable
		ifTrue: [ | belongsTo |
			belongsTo := tmpReceiver belongsTo parentType.
			tmpReceiver isSelf ifTrue: [ ^ belongsTo ].
			tmpReceiver isSuper ifTrue: [ ^ belongsTo superclass ifNil: [ belongsTo ] ] ]
		ifFalse: [ ^ tmpReceiver ]
]

{ #category : #initialization }
FAMIXInvocation >> initialize [

	super initialize.
	signature := 'nosignature'.
]

{ #category : #'Famix-Extensions-testing' }
FAMIXInvocation >> isAPotentialInvocation [
	"test if the sender is a potential invocation"
	| invokedMtdSignature invoRVar invokedMtd |
	invokedMtdSignature := self signature.
	invokedMtdSignature ifNil:[^false].
	invoRVar := self receiver.
			
	invoRVar ifNil:[^true].
	
	(invoRVar isImplicitVariable or: [invoRVar class = FAMIXClass]) ifFalse:[^true].
	
	(invoRVar isImplicitVariable 
	 and: [(invoRVar isSelf or: [invoRVar isSuper]) not]) ifTrue:[^true].
		 
	(invoRVar isImplicitVariable 
	 	and: [(invokedMtd := self getReceivingFAMIXClass lookUp: invokedMtdSignature) isNil 
					or: [invokedMtd isAbstract]]) ifTrue:[^true].

	^false
	
]

{ #category : #'Famix-Extensions-testing' }
FAMIXInvocation >> isASureInvocation [
	"Test if the receiver (an invocation) is sure (i.e. we know for sure the class of the invocation's receiver)"

	| invoRVar |
	invoRVar := self receiver.
	^ invoRVar isNotNil and: [ invoRVar class = FAMIXClass or: [ invoRVar isImplicitVariable and: [ invoRVar isSelf or: [ invoRVar isSuper ] ] ] ]
]

{ #category : #'Famix-Implementation' }
FAMIXInvocation >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $#.
	aStream << self signature.
	aStream << ' (Invocation)'
]

{ #category : #accessing }
FAMIXInvocation >> receiverSourceCode [
	^ self receiver sourceText
]
