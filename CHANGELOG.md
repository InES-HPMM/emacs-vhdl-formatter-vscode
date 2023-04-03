### Changelog

All notable changes to this project will be documented in this file. Dates are displayed in UTC.

#### [v1.1.1](https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/compare/v1.1.0...v1.1.1)

- fix: prevent the insertion of a new line when formatting files with crlf eol [`#1`](https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/issues/1)
- fix: fix link to the changelog in the release body [`05b5726`](https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/commit/05b5726ab97815e598e6d27b966bbf8153316e00)

#### [v1.1.0](https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/compare/v1.0.1...v1.1.0)

> 22 February 2023

- test: add a test for the formatDocument task [`12d44e4`](https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/commit/12d44e40214218bf79adef40e0d1b8d42327178d)
- chore: update dev dependencies [`74c1524`](https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/commit/74c1524167621c338694e4243ef4252e0402840c)
- chore: add pre-commit hooks to lint and format the code [`8baaacf`](https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/commit/8baaacfd774578b848c635551443649778dfb8f0)
- chore: automatically generate the changelog with yarn version [`8805577`](https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/commit/8805577f0654a64fc8c978d7c43fa6492d58fb2d)
- fix: fix dependencies to pass ci tests [`1892caa`](https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/commit/1892caaf9d8d7c42024a6ef80d99548d12b14d95)
- ci: GitHub workflow definition to automatically test, release, and publish the extension [`55b53db`](https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/commit/55b53dbecf91cb22955df116cea1e5298906ba2d)
- chore: update info in package.json [`96f1e14`](https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/commit/96f1e141177ef6cc2b1937ec09f9cf59f044293d)
- refactor: get the evaluated lisp string from a function instead of a string in the code. This allows to retrieve the evaluated lisp string also somewhere else [`f57e5b9`](https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/commit/f57e5b909fadef5231f08f31cf593161b87c90ad)
- docs: typo [`69d5d28`](https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/commit/69d5d2893b60dd7ec8c9007298ec0ed0f2f92f61)

#### [v1.0.1](https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/compare/v1.0.0...v1.0.1)

> 21 December 2022

- BREAKING CHANGE: changed from GPL-3.0-or-later to the MIT license [`23e840e`](https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/commit/23e840effda6216d7c314c5ab5077727e6857b89)

#### v1.0.0

> 15 December 2022

- feat: format VHDL code in emacs (batch mode) [`96f46c6`](https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/commit/96f46c640fa5f5aa0b37aa12406445d0fdc99d57)
- Initial commit [`e075d9e`](https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/commit/e075d9ec6508dc6a9b3e8ab60cccdd375a571650)
