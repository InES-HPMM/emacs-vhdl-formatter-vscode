import * as cp from "child_process";
import * as path from "path";
import {
  downloadAndUnzipVSCode,
  resolveCliArgsFromVSCodeExecutablePath,
  runTests,
} from "@vscode/test-electron";

async function main() {
  try {
    // The folder containing the Extension Manifest package.json
    // Passed to `--extensionDevelopmentPath`
    const extensionDevelopmentPath = path.resolve(__dirname, "../../");

    // The path to the extension test runner script
    // Passed to --extensionTestsPath
    const extensionTestsPath = path.resolve(__dirname, "./suite/index");

    // The path to the workspace file
    const workspacePath = path.resolve("test-fixtures", "test.code-workspace");

    const vscodeExecutablePath = await downloadAndUnzipVSCode();
    const [cliPath, ...args] =
      resolveCliArgsFromVSCodeExecutablePath(vscodeExecutablePath);

    // install a plugin that provides the VHDL filetype support
    cp.spawnSync(
      cliPath,
      [...args, "--install-extension", "rjyoung.vscode-modern-vhdl-support"],
      {
        encoding: "utf-8",
        stdio: "inherit",
      }
    );
    // Run the extension test
    await runTests({
      vscodeExecutablePath,
      extensionDevelopmentPath,
      extensionTestsPath,
      launchArgs: [workspacePath]
        .concat(["--skip-welcome"])
        .concat(["--skip-release-notes"])
        .concat(["--enable-proposed-api"]),
    });
  } catch (err) {
    console.error(err);
    console.error("Failed to run tests");
    process.exit(1);
  }
}

main();
