import Danger
import DangerSwiftKantoku

let danger = Danger()
let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles

if allSourceFiles.first(where: { $0.fileType == .swift }) != nil {
    let violations = SwiftLint.lint()
    if violations.isEmpty {
        message("No violation found!!!")
    }
    for violation in violations {
        warn(message: violation.reason, file: violation.file, line: violation.line)
    }
} else {
    message("No .swift file was added")
}

danger.kantoku.parseXCResultFile(at: "TestResults.xcresult", configuration: .default)
