/*
 *  Copyright (c) 2024, WSO2 LLC. (https://www.wso2.com).
 *
 *  WSO2 LLC. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied. See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

package org.ballerinalang.formatter.core.configurations;

import io.ballerina.projects.util.ProjectUtils;
import org.ballerinalang.formatter.core.FormatterException;
import org.ballerinalang.formatter.core.FormatterUtils;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * Test resolution of formatting configuration file.
 *
 * @since 2201.9.0
 */
public class FormatFileResolutionTest {

    private final Path resDir = Path.of("src", "test", "resources", "configurations", "resolution");
    private final String validRemoteUrl =
            "https://gist.githubusercontent.com/ballerina-bot/ae54cc7303e9d474d730d732c1594c61/raw" +
                    "/db0909d0b66f97cd0035f19bcb7cde9a239f5d54/format.toml";
    private final Path validRemote = resDir.resolve("validRemote");
    private final Path withTarget = resDir.resolve("withTarget");
    private final Path invalidLocal = resDir.resolve("invalidLocal");
    private final Path invalidCached = resDir.resolve(Path.of("invalidCached"));
    private final Path invalidCacheTarget = resDir.resolve("invalidCacheTarget");
    private final Path invalidCacheWrite = resDir.resolve("invalidCacheWrite");

    // In the case of tests failing to run, check whether these temp files exists and delete them if so.
    private File tempInvalidPermissionFile;
    private File tempInvalidCachedPermissionFile;
    private File tempInvalidTargetDir;
    private File tempInvalidFormatDir;

    @BeforeClass
    public void setup() {
        try {
            tempInvalidPermissionFile = createTempUnreadableFile(invalidLocal.resolve("Format.toml"));
            tempInvalidCachedPermissionFile =
                    createTempUnreadableFile(invalidCached.resolve(Path.of("target", "format", "Format.toml")));
            tempInvalidTargetDir = createTempUnwritableDir(invalidCacheTarget.resolve("target"));
            tempInvalidFormatDir = createTempUnwritableDir(invalidCacheWrite.resolve("target").resolve("format"));

        } catch (IOException e) {
            throw new RuntimeException("Error while setting up the formatter resolution test.");
        }
    }

    @Test(description = "Test for local formatting configuration file")
    public void resolutionOfLocalFormatFileTest() throws FormatterException {
        Path validLocal = resDir.resolve("validLocal");
        FormatterUtils.getFormattingConfigurations(validLocal, validLocal.resolve("Format.toml").toString());
    }

    @Test(description = "Test for remote formatting configuration file")
    public void resolutionOfRemoteFormatFileTest() throws FormatterException {
        FormatterUtils.getFormattingConfigurations(validRemote, validRemoteUrl);
    }

    @Test(description = "Test caching of configuration file with target directory present")
    public void cacheWithTargetDirectoryPresent() throws FormatterException {
        FormatterUtils.getFormattingConfigurations(withTarget, validRemoteUrl);
    }

    @Test(description = "Test invalid local formatting configuration files",
            expectedExceptions = FormatterException.class,
            expectedExceptionsMessageRegExp = "Failed to retrieve local formatting configuration file")
    public void invalidLocalFormatFileTest() throws FormatterException {
        FormatterUtils.getFormattingConfigurations(invalidLocal, invalidLocal.resolve("directory.toml").toString());
        FormatterUtils.getFormattingConfigurations(invalidLocal, tempInvalidPermissionFile.toString());
    }

    @Test(description = "Test invalid remote cached formatting configuration files",
            expectedExceptions = FormatterException.class,
            expectedExceptionsMessageRegExp = "Failed to read cached formatting configuration file")
    public void invalidRemoteCachedFormatFileTest() throws FormatterException {
        FormatterUtils.getFormattingConfigurations(invalidCached, validRemoteUrl);
    }

    @Test(description = "Test invalid remote formatting configuration file url",
            expectedExceptions = FormatterException.class,
            expectedExceptionsMessageRegExp = "Failed to retrieve remote file. HTTP response code:.*")
    public void invalidRemoteFormatFileURLTest() throws FormatterException {
        Path invalidUrl = resDir.resolve("invalidUrl");
        FormatterUtils.getFormattingConfigurations(invalidUrl,
                "https://gist.github.com/ballerina-bot/ae54cc7303e9d474d730d732c1594c61/Format.toml");
    }

    @Test(description = "Test invalid formatting configuration files", expectedExceptions = FormatterException.class,
            expectedExceptionsMessageRegExp = "Failed to retrieve formatting configuration file")
    public void getInvalidFormatFileTest() throws FormatterException {
        FormatterUtils.getFormattingConfigurations(invalidLocal, invalidLocal.resolve("t.toml").toString());
    }

    @Test(description = "Test invalid formatting configuration files", expectedExceptions = FormatterException.class,
            expectedExceptionsMessageRegExp = "Failed to create format configuration cache directory")
    public void failureToCreateFormatCacheFolderTest() throws FormatterException {
        FormatterUtils.getFormattingConfigurations(invalidCacheTarget, validRemoteUrl);
    }

    @Test(description = "Test invalid formatting configuration files", expectedExceptions = FormatterException.class,
            expectedExceptionsMessageRegExp = "Failed to write format configuration cache file")
    public void failureToWriteCacheFileTest() throws FormatterException {
        FormatterUtils.getFormattingConfigurations(invalidCacheWrite, validRemoteUrl);
    }

    private File createTempUnreadableFile(Path path) throws IOException {
        Files.deleteIfExists(path);
        File file = new File(path.toString());
        file.createNewFile();
        file.setReadable(false);
        return file;
    }

    private File createTempUnwritableDir(Path path) throws IOException {
        Files.deleteIfExists(path);
        File dir = new File(path.toString());
        dir.mkdir();
        dir.setWritable(false);
        return dir;
    }

    @AfterClass
    public void tearDown() {
        ProjectUtils.deleteDirectory(validRemote.resolve("target"));
        ProjectUtils.deleteDirectory(withTarget.resolve("target").resolve("format"));
        tempInvalidPermissionFile.delete();
        tempInvalidCachedPermissionFile.delete();
        tempInvalidTargetDir.delete();
        tempInvalidFormatDir.delete();
    }

}
