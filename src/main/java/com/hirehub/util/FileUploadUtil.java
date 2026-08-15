package com.hirehub.util;

import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

public class FileUploadUtil {

    private static final List<String> ALLOWED_RESUME_EXTENSIONS = Arrays.asList(".pdf", ".doc", ".docx");
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5 MB

    public static String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String token : contentDisposition.split(";")) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return null;
    }

    public static boolean isValidResume(Part part) {
        if (part == null || part.getSize() == 0) return false;
        if (part.getSize() > MAX_FILE_SIZE) return false;
        
        String fileName = getFileName(part);
        if (fileName == null) return false;
        
        String lowerName = fileName.toLowerCase();
        for (String ext : ALLOWED_RESUME_EXTENSIONS) {
            if (lowerName.endsWith(ext)) return true;
        }
        return false;
    }

    public static String saveFile(Part part, String uploadDir) throws IOException {
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        
        String originalName = getFileName(part);
        String extension = "";
        int i = originalName.lastIndexOf('.');
        if (i >= 0) {
            extension = originalName.substring(i);
        }
        
        String uniqueFileName = UUID.randomUUID().toString() + extension;
        File file = new File(dir, uniqueFileName);
        
        try (InputStream input = part.getInputStream()) {
            Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }
        
        return uniqueFileName;
    }
}
