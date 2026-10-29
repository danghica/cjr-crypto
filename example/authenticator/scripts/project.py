import subprocess,sys
from pathlib import Path
root=Path(__file__).resolve().parents[1]
mode=sys.argv[1]
commands={'cli':[['scripts/frontends.py','cli']], 'ui':[['scripts/frontends.py','ui']], 'frontends':[['scripts/frontends.py','cli'],['scripts/frontends.py','ui']], 'frontend-test':[['scripts/check_frontends.py']], 'docs-check':[['scripts/check_docs.py']]}
for command in commands[mode]: subprocess.run([sys.executable,*command],cwd=root,check=True)
