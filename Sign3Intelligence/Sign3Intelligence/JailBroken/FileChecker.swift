////
////  FileChecker.swift
////  Sign3Intelligence
////
////  Created by Ashish Gupta on 02/12/24.
////
//
internal class FileChecker {
//    typealias CheckResult = (passed: Bool, failMessage: String)
//    
    struct MountedVolumeInfo {
        let fileSystemName: String
        let directoryName: String
        let isRoot: Bool
        let isReadOnly: Bool
    }
    
    enum FileMode {
        case readable
        case writable
    }
    
    static func checkExistenceOfSuspiciousFilesViaFOpen(path: String, mode: FileMode) -> Bool {
        let modeString: String = mode == .writable ? "r+" : "r"
        if let filePointer: UnsafeMutablePointer<FILE> = fopen(path, modeString) {
            fclose(filePointer)
            return true
        } else {
            return false
        }
    }
    
    static func checkExistenceOfSuspiciousFilesViaStat(path: String) -> Bool {
        var statbuf: stat = stat()
        let resultCode = stat((path as NSString).fileSystemRepresentation, &statbuf)
        return resultCode == 0
    }
    
    static func checkExistenceOfSuspiciousFilesViaAccess(path: String, mode: FileMode) -> Bool {
        let resultCode = access(
            (path as NSString).fileSystemRepresentation,
            mode == .writable ? W_OK : R_OK
        )
        return resultCode == 0
    }
    
    static func checkRestrictedPathIsReadonlyViaStatvfs(path: String, encoding: String.Encoding = .utf8) -> Bool? {
        guard let path: [CChar] = path.cString(using: encoding) else {
            assertionFailure("Failed to create a cString with path=\(path) encoding=\(encoding)")
            return nil
        }
        var statBuffer = statvfs()
        let resultCode: Int32 = statvfs(path, &statBuffer)
        return resultCode == 0 ? (Int32(statBuffer.f_flag) & ST_RDONLY != 0) : nil
    }
    
    static func checkRestrictedPathIsReadonlyViaStatfs(path: String, encoding: String.Encoding = .utf8) -> Bool? {
        return getMountedVolumeInfoViaStatfs(path: path, encoding: encoding)?.isReadOnly
    }
    
    static func checkRestrictedPathIsReadonlyViaGetfsstat(name: String) -> Bool? {
        return self.getMountedVolumesViaGetfsstat(withName: name)?.isReadOnly
    }
    
    private static func getMountedVolumeInfoViaStatfs(
        path: String,
        encoding: String.Encoding = .utf8
    ) -> MountedVolumeInfo? {
        guard let path: [CChar] = path.cString(using: encoding) else {
            assertionFailure("Failed to create a cString with path=\(path) encoding=\(encoding)")
            return nil
        }
        
        var statBuffer = statfs()
        /**
         Upon successful completion, the value 0 is returned; otherwise the
         value -1 is returned and the global variable errno is set to indicate
         the error.
         */
        let resultCode: Int32 = statfs(path, &statBuffer)
        
        if resultCode == 0 {
            let mntFromName: String = withUnsafePointer(to: statBuffer.f_mntfromname) { ptr -> String in
                return String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
            }
            let mntOnName: String = withUnsafePointer(to: statBuffer.f_mntonname) { ptr -> String in
                return String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
            }
            
            return MountedVolumeInfo(fileSystemName: mntFromName,
                                     directoryName: mntOnName,
                                     isRoot: (Int32(statBuffer.f_flags) & MNT_ROOTFS) != 0,
                                     isReadOnly: (Int32(statBuffer.f_flags) & MNT_RDONLY) != 0)
        } else {
            return nil
        }
    }
    
    private static func getMountedVolumesViaGetfsstat() -> [MountedVolumeInfo]? {
        // If buf is NULL, getfsstat() returns just the number of mounted file systems.
        let count: Int32 = getfsstat(nil, 0, MNT_NOWAIT)
        
        guard count >= 0 else {
            assertionFailure("getfsstat() failed to return the number of mounted file systems.")
            return nil
        }
        
        var statBuffer: [statfs] = .init(repeating: .init(), count: Int(count))
        let size: Int = MemoryLayout<statfs>.size * statBuffer.count
        /**
         Upon successful completion, the number of statfs structures is
         returned. Otherwise, -1 is returned and the global variable errno is
         set to indicate the error.
         */
        let resultCode: Int32 = getfsstat(&statBuffer, Int32(size), MNT_NOWAIT)
        
        if resultCode > -1 {
            if count != resultCode {
                assertionFailure("Unexpected a resultCode=\(resultCode), was expecting=\(count).")
            }
            
            var result: [MountedVolumeInfo] = []
            
            for entry: statfs in statBuffer {
                let mntFromName: String = withUnsafePointer(to: entry.f_mntfromname) { ptr -> String in
                    return String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
                }
                let mntOnName: String = withUnsafePointer(to: entry.f_mntonname) { ptr -> String in
                    return String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
                }
                
                let info = MountedVolumeInfo(fileSystemName: mntFromName,
                                             directoryName: mntOnName,
                                             isRoot: (Int32(entry.f_flags) & MNT_ROOTFS) != 0,
                                             isReadOnly: (Int32(entry.f_flags) & MNT_RDONLY) != 0)
                result.append(info)
            }
            
            if count != result.count {
                assertionFailure("Unexpected filesystems count=\(result.count), was expecting=\(count).")
            }
            
            return result
        } else {
            assertionFailure(
                "getfsstat() failed. resultCode=\(resultCode), expected count=\(count) filesystems."
            )
            return nil
        }
    }
//    
    private static func getMountedVolumesViaGetfsstat(withName name: String) -> MountedVolumeInfo? {
        return getMountedVolumesViaGetfsstat()?.first { $0.directoryName == name || $0.fileSystemName == name }
    }
}
