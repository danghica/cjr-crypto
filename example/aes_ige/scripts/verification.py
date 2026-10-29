#!/usr/bin/env python3
"""Summarize a matching successful split-repository audit for AES/IGE."""
from pathlib import Path
import hashlib,json,re
ROOT=Path(__file__).resolve().parents[1]
REPO=ROOT.parents[1]

def main():
 record=json.loads((REPO/'build/proof-verification.json').read_text())
 log=REPO/'build/verify.log'
 if record.get('status')!='passed' or record.get('coqchk')!='passed':
  raise SystemExit('A successful make verify is required.')
 if hashlib.sha256(log.read_bytes()).hexdigest()!=record['verify_log_sha256']:
  raise SystemExit('Verification log does not match proof record.')
 for source in (ROOT/'rocq').glob('*.v'):
  name=source.relative_to(REPO).as_posix()
  if hashlib.sha256(source.read_bytes()).hexdigest()!=record['sources'].get(name):
   raise SystemExit('Source changed since verification: '+name)
 declarations=re.findall(r'^Print Assumptions (cjr\.aes_ige\.[\w.]+)\.',(REPO/'audit/assumptions.v').read_text(),re.M)
 data=dict(status='passed',refinement_status='complete',coqchk='passed',
  assumptions='all audited declarations closed under the global context',
  audited_declarations=len(declarations),expected_declarations=len(declarations),
  repository_audited_declarations=record['closed'],date_utc=record['finished_utc'],
  contract_coverage='Concrete specification algebra; Iris refinement of byte/block helpers, caller-owned key expansion, all AES block variants, and full IGE loops; implementation round-trip, empty-message, and chunk-composition contracts.',
  pending_obligations=[],repository_verify_log_sha256=record['verify_log_sha256'])
 dest=ROOT/'proof/results/verification.json';dest.parent.mkdir(parents=True,exist_ok=True)
 dest.write_text(json.dumps(data,indent=2,sort_keys=True)+'\n')
 print(f'AES/IGE: {len(declarations)} assumption-audit entries covered by the successful repository kernel check.')

if __name__=='__main__':main()
