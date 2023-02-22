import * as assert from "assert";
import { readFile } from "fs";
import * as path from "path";
import { promisify } from "util";
import * as vscode from "vscode";

const readFileAsync: (filePath: string, encoding: "utf8") => Promise<string> =
  promisify(readFile);

/**
 * Get the workspace folder by name.
 * @param workspaceFolderName The name of the workspace folder
 */
export const getWorkspaceFolderUri = (workspaceFolderName: string) => {
  const workspaceFolder = vscode.workspace.workspaceFolders!.find((folder) => {
    return folder.name === workspaceFolderName;
  });
  if (!workspaceFolder) {
    throw new Error(
      "Folder not found in workspace. Did you forget to add the test folder to test.code-workspace?"
    );
  }
  return workspaceFolder!.uri;
};

/**
 * Get the content of the the named file in the workspace folder.
 * @param workspaceFolderName The name of the workspace folder
 * @param fileName The name of the file
 * @returns The content of the file
 */
export async function getText(workspaceFolderName: string, fileName: string) {
  const base = getWorkspaceFolderUri(workspaceFolderName);
  const filePath = path.join(base.fsPath, fileName);
  const content = await readFileAsync(filePath, "utf8");
  return content;
}

/**
 * Load and format a file.
 * @param workspaceFolderName The name of the workspace folder
 * @param fileName The file name of the test file
 * @returns The source and actual content after formatting
 */
export async function format(workspaceFolderName: string, fileName: string) {
  const base = getWorkspaceFolderUri(workspaceFolderName);
  const absPath = path.join(base.fsPath, fileName);
  const doc = await vscode.workspace.openTextDocument(absPath);
  const text = doc.getText();
  try {
    await vscode.window.showTextDocument(doc);
  } catch (err) {
    console.log(err);
    throw err;
  }
  // Calling the command twice seems to resolve the issue that the command
  // doesn't get executed on the first call
  console.time(fileName);
  await vscode.commands.executeCommand("editor.action.formatDocument");
  await vscode.commands.executeCommand("editor.action.formatDocument");
  console.timeEnd(fileName);

  return { actual: doc.getText(), source: text };
}
/**
 * Compare the golden file to the formatted output of the file
 * @param fileName The name of the file
 * @param goldenFileName The name of the golden file
 */
async function formatSameAsGoldenFile(
  fileName: string,
  goldenFileName: string
) {
  const { actual, source } = await format("formatTest", fileName);
  const emacsFormatted = await getText("formatTest", goldenFileName);
  assert.equal(actual, emacsFormatted);
}

suite("Test formatDocument", function () {
  this.timeout(10000);
  test("VHDL", () =>
    formatSameAsGoldenFile("stopwatch.vhd", "stopwatch_emacs.vhd"));
});
