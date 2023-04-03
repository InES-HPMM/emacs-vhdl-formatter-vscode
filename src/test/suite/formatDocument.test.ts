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
 * Compare the format Document functionality against a golden output directly
 * from emacs.
 * @param fileName The name of the file
 * @param goldenFileName The name of the golden file
 */
async function formatDocument(
  fileName: string,
  goldenFileName: string
) {
  const { actual, source } = await format("formatDocument", fileName);
  const emacsFormatted = await getText("formatDocument", goldenFileName);
  assert.equal(actual, emacsFormatted);
}

suite("Test formatDocument", function () {
  this.timeout(10000);
  test("format VHDL", () =>
    formatDocument("stopwatch.vhd", "stopwatch_emacs.vhd"));
});

/**
 * Test if issue #1 is resolved (see https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/issues/1)
 * @param fileName The name of the file
 * @param goldenFileName The name of the golden file
 */
async function formatDocumentIssue1(fileName: string, goldenFileName: string) {
  const { actual, source } = await format("issue1", fileName);
  const emacsFormatted = await getText("issue1", goldenFileName);
  assert.equal(actual, emacsFormatted);
}

suite("Test formatDocument (issue1)", function () {
  this.timeout(10000);
  test("issue1", () =>
    formatDocumentIssue1("stopwatch_crlf.vhd", "stopwatch_crlf_emacs.vhd"));
});
