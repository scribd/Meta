import XCTest
import Meta

final class FileTests: XCTestCase {
    
    func test_file_should_generate_valid_swift_code() {
        
        let fooProtocolID = TypeIdentifier(name: "FooProtocol")
        let fooProtocol = Type(identifier: fooProtocolID)
            .with(kind: .protocol)
            .with(accessLevel: .private)
            .adding(member: ProtocolProperty(name: "storedMessage", type: .string))
        
        let fooID = TypeIdentifier(name: "Foo")
        let fuuID = TypeIdentifier(name: "Fuu")
        
        let storedMessage = Reference.named("storedMessage") | .unwrap

        let foo = Type(identifier: fooID)
            .adding(genericParameter: GenericParameter(name: "K"))
            .adding(genericParameter: GenericParameter(name: "V"))
            .adding(inheritedType: fooProtocolID)
            .with(accessLevel: .public)
            .adding(member: EmptyLine())
            .adding(member:
                Property(variable:Variable(name: "storedMessage"))
                    .with(value: Value.string("Hello stored World!"))
                    .with(accessLevel: .private)
            )
            .adding(member: EmptyLine())
            .adding(member:
                Function(kind: .init(convenience: false))
                    .with(throws: true)
                    .adding(parameter:
                        FunctionParameter(name: "fuu", type: fuuID).with(defaultValue:
                            .named("Constants") + .named("fuu")
                        )
                    )
                    .adding(member: Assignment(
                        variable: Variable(name: "message").with(type: .string),
                        value: .type(.string) | .call(Tuple().adding(parameter: TupleParameter(value: Value.string("Hello World!"))))
                    ))
                    .adding(member:
                        .try |
                        .named(.print) |
                        .call(Tuple().adding(parameter: TupleParameter(value: Reference.named("message"))))
                    )
                    .adding(member: EmptyLine())
                    .adding(member: Comment.comment("stored message"))
                    .adding(member: .named(.print) |
                        .call(Tuple().adding(parameter:
                            TupleParameter(value: .named(.`self`) + .named("storedMessage"))
                        ))
                    )
                )
            .adding(member: EmptyLine())
            .adding(member:
                ComputedProperty(variable: Variable(name: "description")
                    .with(immutable: false)
                    .with(type: TypeIdentifier.optional(wrapped: .string))
                )
                .adding(member: Return(value: storedMessage + .named("capitalized")))
                .with(accessLevel: .public)
            )
            .adding(member: EmptyLine())
            .adding(member:
                Property(variable:
                    Variable(name: "lowercasedMessage")
                        .with(immutable: true)
                        .with(type: TypeIdentifier.optional(wrapped: .string))
                    )
                    .with(accessLevel: .public)
                    .with(value: FunctionBody()
                        .adding(member: Return(value: storedMessage + .named("lowercased")))
                        .with(tuple: Tuple())
                    )
            )

        let fooExtension = Extension(name: "Foo")
            .adding(inheritedType: TypeIdentifier(name: "ErrorPrintable"))
            .with(accessLevel: .private)
            .adding(member:
                Function(kind: .named("printError"))
                    .with(resultType: TypeIdentifier.bool)
                    .adding(member: .type(TypeIdentifier(name: "Logger")) + .named("error") | .call(Tuple()
                        .adding(parameter: TupleParameter(value: +.named("error")))
                        .adding(parameter: TupleParameter(value: Reference.named("lowercasedMessage")))
                        .adding(parameter: TupleParameter(name: "assert", value: Value.bool(true))))
                    )
                    .adding(member: Return(value: Value.bool(true))
                )
            )
        
        let barID = TypeIdentifier(name: "Bar")
        let bar = Type(identifier: barID)
            .adding(inheritedType: .string)
            .with(kind: .enum)
            .with(accessLevel: .public)
            .adding(member: Case(name: "hello").with(value: .string("Hello")))
            .adding(member: Case(name: "world"))
            .adding(member: Case(name: "message").adding(parameter: CaseParameter(name: "content", type: .string)))
            .adding(member: EmptyLine())
            .adding(member: ComputedProperty(variable: Variable(name: "string").with(type: .string))
                .with(accessLevel: .public)
                .adding(member: Switch(reference: .named(.`self`))
                    .adding(case: SwitchCase(name: "hello").adding(member: Return(value: Reference.named("rawValue"))))
                    .adding(case: SwitchCase(name: "world").adding(member: Return(value: Value.string("World"))))
                    .adding(case: SwitchCase(name: "message")
                        .adding(value: SwitchCaseVariable(name: "content", as: .string))
                        .adding(member: Return(value: Reference.named("content")))
                    )
                    .adding(case: SwitchCase()
                        .adding(value: SwitchCaseVariable(name: "string", as: .string))
                        .adding(member: Return(value: Reference.named("string")))
                    )
                )
            )
        
        
        let file = File(name: "Meta")
            .with(header: [.empty,
                           .comment("File.swift"),
                           .comment("Meta"),
                           .empty,
                           .comment("Created by Bob."),
                           .empty])
            .adding(import: Import(name: "Meta"))
            .adding(member: fooProtocol)
            .adding(member: EmptyLine())
            .adding(member: foo)
            .adding(member: EmptyLine())
            .adding(member: fooExtension)
            .adding(member: EmptyLine())
            .adding(member: bar)
        
        XCTAssertEqual(file.swiftString, """
        //
        // File.swift
        // Meta
        //
        // Created by Bob.
        //
        
        import Meta
        
        private protocol FooProtocol {
            var storedMessage: String { get }
        }
        
        public final class Foo<K, V>: FooProtocol {
        
            private let storedMessage = "Hello stored World!"
        
            init(fuu: Fuu = Constants.fuu) throws {
                let message: String = String("Hello World!")
                try print(message)
        
                // stored message
                print(self.storedMessage)
            }
        
            public var description: Optional<String> {
                return storedMessage?.capitalized
            }
        
            public let lowercasedMessage: Optional<String> = { return storedMessage?.lowercased }()
        }
        
        private extension Foo: ErrorPrintable {
            func printError() -> Bool {
                Logger.error(.error, lowercasedMessage, assert: true)
                return true
            }
        }
        
        public enum Bar: String {
            case hello = "Hello"
            case world
            case message(content: String)
        
            public var string: String {
                switch self {
                case .hello:
                    return rawValue
                case .world:
                    return "World"
                case .message(let content as String):
                    return content
                case let string as String:
                    return string
                }
            }
        }

        """)
    }
}
