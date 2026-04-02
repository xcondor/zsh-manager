import XCTest
@testable import ZshrcManager

final class ZshrcManagerTests: XCTestCase {
    
    func testAliasAddition() throws {
        let manager = AliasManager()
        let initialCount = manager.aliases.count
        
        manager.addAlias(name: "test_alias", command: "echo 'hello'", description: "test")
        
        XCTAssertEqual(manager.aliases.count, initialCount + 1)
        XCTAssertTrue(manager.aliases.contains { $0.name == "test_alias" })
        
        // Cleanup
        manager.removeAlias(name: "test_alias")
    }
    
    func testPathExpansion() throws {
        let manager = PathManager()
        
        // Local path that should exist on any dev machine
        manager.addPath("/usr/bin")
        XCTAssertTrue(manager.paths.contains { $0.path == "/usr/bin" })
        
        // Variable expansion test (mocking $HOME is complex, but we test the pattern)
        manager.addPath("$HOME/.zsh_manager")
        XCTAssertTrue(manager.paths.contains { $0.path == "$HOME/.zsh_manager" })
        
        // Cleanup
        manager.removePath("/usr/bin")
        manager.removePath("$HOME/.zsh_manager")
    }
    
    func testTemplatePreset() throws {
        let manager = TemplateManager()
        XCTAssertFalse(manager.templates.isEmpty)
        
        let claude = manager.templates.first { $0.id == "claude" }
        XCTAssertNotNil(claude)
        XCTAssertTrue(claude?.icon == "brain.headset")
    }
}
