#!/usr/bin/env python3
"""Run the @example blocks in the shell library and check their output.

Usage: python3 -I tools/doctest-shell-lib.py home/dot_config/shell/lib

Each example command runs in a fresh fixture folder (notes.txt, app.conf,
doc.md, photos/) with every library file of its kind sourced. Lines starting
with "#=>" under a command are its expected output. sh examples run under
dash and zsh (sh emulation), bash examples under bash, zsh examples
under zsh; missing shells are skipped. Examples with varying output, and bash examples marked
"Requires bash 4+" when the local bash is older, are skipped.
Exits 1 if any example fails.
"""
import sys, re, glob, os, subprocess, tempfile, shutil
lib = sys.argv[1]
SKIP = {'arr_random','path_script_dir','sys_is_sourced','sys_arch','sys_edit','sys_hostname','sys_sleep','sys_date','sys_username','sys_uuid',
        'sys_functions','sys_background','term_size','term_window_size','term_cursor_pos','term_progress_bar'}
def fixture():
    d = tempfile.mkdtemp()
    open(f'{d}/notes.txt','w').write('line 1\nline 2\nline 3\nline 4\n')
    open(f'{d}/app.conf','w').write('# comment\nname=demo\nport=8080')
    open(f'{d}/doc.md','w').write('a\n<!-- start -->\nkeep me\n<!-- end -->\nb\n')
    os.makedirs(f'{d}/photos/2024')
    for f in ('photos/a.jpg','photos/b.jpg','photos/2024/c.jpg'): open(f'{d}/{f}','w').close()
    return d
def examples(path):
    lines = open(path).read().split('\n'); res = []; block = []
    for l in lines:
        m = re.match(r'^([a-z_]+)\(\) \{', l)
        if m:
            needs = any('Requires bash' in b for b in block)
            inex = False; cur = None
            for b in block:
                if b.startswith('# @'):
                    inex = b.startswith('# @example'); continue
                if not inex: continue
                if b.strip() == '#': inex = False; continue
                t = b[4:]
                if t.startswith('#=> '): cur[1].append(t[4:].rstrip())
                elif t == '#=>': cur[1].append('')
                else: cur = [t, []]; res.append((m.group(1), needs, cur))
            block = []
        elif l.startswith('#'): block.append(l)
        else: block = []
    return res
shells = {'sh': [s for s in (['dash','-c'], ['zsh','-c']) if shutil.which(s[0])],
          'bash': [['bash','-c']],
          'zsh': [s for s in (['zsh','-c'],) if shutil.which(s[0])]}
bash_ver = subprocess.run(['bash','-c','echo ${BASH_VERSINFO[0]}'], capture_output=True, text=True).stdout.strip()
old_bash = not bash_ver.isdigit() or int(bash_ver) < 4
fails = ran = skipped = 0; seen = set()
for ext in ('sh','bash','zsh'):
    files = sorted(glob.glob(f'{lib}/{ext}/*.{ext}'))
    src = '; '.join(f'. {f}' for f in files)
    for path in files:
        for name, needs, (cmd, want) in examples(path):
            seen.add(f'{ext}:{name}')
            if name in SKIP or (ext == 'bash' and needs and old_bash): skipped += 1; continue
            for sh in shells[ext]:
                d = fixture()
                script = f"emulate sh -c '{src}'; cd {d}; {cmd}" if sh[0]=='zsh' and ext=='sh' else f'{src}; cd {d}; {cmd}'
                raw = subprocess.run(sh+[script], capture_output=True, text=True).stdout.rstrip('\n')
                out = '\n'.join(x.rstrip() for x in raw.split('\n'))
                ran += 1
                if out != '\n'.join(want):
                    fails += 1; print(f'FAIL [{sh[0]}] {ext}/{name}: {cmd}\n  got:  {out!r}\n  want: {chr(10).join(want)!r}')
                shutil.rmtree(d)
print(f'ran {ran}, failed {fails}, skipped {skipped}, functions with examples {len(seen)}')
sys.exit(1 if fails else 0)
