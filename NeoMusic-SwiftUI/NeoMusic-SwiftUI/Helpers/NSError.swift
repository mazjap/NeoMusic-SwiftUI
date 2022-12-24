import Foundation

func nserror(_ error: Error, file: String = #file, function: String = #function, line: UInt = #line) {
    nserror(error.localizedDescription, file: file, function: function, line: line)
}

func nserror(_ error: String, file: String = #file, function: String = #function, line: UInt = #line) {
    nslog("\tError in \(file) at #\(line) (\(function)):\n\t\t\(error)")
}

func nslog(_ format: String, args: CVarArg...) {
    NSLog(format, args)
}

