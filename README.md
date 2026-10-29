# cjr-crypto

CJR AES/IGE and the memory-only authenticator core, command-line adapter, and macOS SwiftUI adapter.

Open [HTML documentation](docs/index.html) or the [tutorial PDF](paper/tutorial.pdf).

## Setup

Use Python 3.10+, Cangjie 1.0.5, and pdfLaTeX. Proof work additionally needs Coq 8.20.1, stdpp 1.12.0, Iris 4.4.0 and coq-lsp 0.2.5+8.20 for readable specification regeneration. `CJC`, `CANGJIE_HOME`, and `SDKROOT` override the native toolchain.

Dependencies are pinned in dependencies.lock.json. Place checkouts alongside this repository or set `CJR_CORE_DIR` and `CJR_COLLECTIONS_DIR`. `make dependencies` checks versions and generates Rocq load paths. Public repository: [danghica/cjr-crypto](https://github.com/danghica/cjr-crypto).

## Commands

- `make test`: compile and test checked-in Cangjie, without proof builds.
- `make benchmark`: collect fresh runtime samples, validate checksums, and create charts and HTML.
- `make docs` or `make report`: assemble offline documentation without checking proofs or rerunning benchmarks.
- `make paper`: refresh the benchmark chapter and compile the tutorial PDF twice.
- `make build`: compile this repository's proofs and required dependencies.
- `make extract`: explicitly build proofs and regenerate Cangjie.
- `make verify`: proof checking and the local assumption audit, with build/verify.log.
- `make readable`: regenerate specification HTML using rocq_readable in core; this invokes the proof backend.

Use `ARGS="--example NAME"` to restrict runtime tests or benchmarks. Examples without a benchmark harness are included in runtime tests but have no timing claim. Historical benchmark runs retain original dates and hashes under benchmark/history; current measurements live under benchmark/results.

## Verification status

**Proof validation passed on 2026-10-29** with Coq 8.20.1. All 99 local source modules compiled and passed `coqchk`; all 842/842 entries in the repository assumption audit reported **Closed under the global context**. The source scan rejects admissions, aborted proofs, and declared axioms.

- [Complete verification log](build/verify.log), including build commands, kernel checking, assumption-audit output, timestamps, and exit status.
- [Machine-readable proof record](build/proof-verification.json), including source SHA-256 fingerprints and pinned dependency commits.

Reproduce with `make verify` after checking out the versions in `dependencies.lock.json`. Proof validation checks the CJR model and stated contracts; native extraction, compilation, external adapters, and machine-integer bounds retain their documented trust boundaries. Runtime checks remain separately recorded in [runtime-validation.json](build/runtime-validation.json).

Proofs were not checked during the initial split; this record supersedes that earlier status for the source files it fingerprints. Imported readable-specification pages and historical benchmark records retain their original provenance.

The additional [authenticator application-gate record](example/authenticator/build/proof-report.json) covers all 69 authenticator modules, all 580 named declarations, and the contract mapping for all 20 extracted functions. Detailed [kernel-check output](example/authenticator/build/proof-check.log) and [assumption-audit output](example/authenticator/build/proof-assumptions.log) are retained. Refresh this gate after `make verify` with `python3 example/authenticator/core/scripts/verify.py`.

The [AES/IGE proof record](example/aes_ige/proof/results/verification.json) records all 262 AES assumption-audit entries covered by the successful repository kernel check. Refresh it with `python3 example/aes_ige/scripts/verification.py`.
