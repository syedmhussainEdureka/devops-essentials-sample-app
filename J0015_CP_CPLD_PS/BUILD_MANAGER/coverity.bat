
1	#!/usr/bin/python
2	# Copyright (c) 2009 The Chromium Authors. All rights reserved.
3	# Use of this source code is governed by a BSD-style license that can be
4	# found in the LICENSE file.
5	
6	"""
7	Runs Coverity Prevent on a build of Chromium.
8	
9	This script should be run in a Visual Studio Command Prompt, so that the
10	INCLUDE, LIB, and PATH environment variables are set properly for Visual
11	Studio.
12	
13	Usage examples:
14	  coverity.py
15	  coverity.py --dry-run
16	  coverity.py --target=debug
17	  %comspec% /c ""C:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"
18	      x86 && C:\Python24\python.exe C:\coverity.py"
19	
20	For a full list of options, pass the '--help' switch.
21	
22	"""
23	
24	import optparse
25	import os
26	import subprocess
27	import sys
28	import time
29	
30	# TODO(wtc): Change these constants to command-line flags, particularly the
31	# ones that are paths.  Set default values for the flags.
32	
33	CHROMIUM_SOURCE_DIR = 'E:\\chromium.latest'
34	
35	# Relative to CHROMIUM_SOURCE_DIR.
36	CHROMIUM_SOLUTION_FILE = 'src\\chrome\\chrome.sln'
37	
38	# Relative to CHROMIUM_SOURCE_DIR.
39	CHROMIUM_SOLUTION_DIR = 'src\\chrome'
40	
41	COVERITY_BIN_DIR = 'C:\\coverity\\prevent-mingw-4.4.0\\bin'
42	
43	COVERITY_INTERMEDIATE_DIR = 'C:\\coverity\\cvbuild\\cr_int'
44	
45	COVERITY_DATABASE_DIR = 'C:\\coverity\\cvbuild\\db'
46	
47	COVERITY_ANALYZE_OPTIONS = ('--all --enable-single-virtual '
48	                            '--enable-constraint-fpp '
49	                            '--enable-callgraph-metrics '
50	                            '--checker-option PASS_BY_VALUE:size_threshold:16')
51	
52	COVERITY_PRODUCT = 'Chromium'
53	
54	COVERITY_USER = 'admin'
55	
56	# Relative to CHROMIUM_SOURCE_DIR.  Contains the pid of this script.
57	LOCK_FILE = 'coverity.lock'
58	
59	def _RunCommand(cmd, dry_run, shell=False):
60	  """Runs the command if dry_run is false, otherwise just prints the command."""
61	  print cmd
62	  # TODO(wtc): Check the return value of subprocess.call, which is the return
63	  # value of the command.
64	  if not dry_run:
65	    subprocess.call(cmd, shell=shell)
66	
67	def main(options, args):
68	  """Runs all the selected tests for the given build type and target."""
69	  # Create the lock file to prevent another instance of this script from
70	  # running.
71	  lock_filename = '%s\\%s' % (CHROMIUM_SOURCE_DIR, LOCK_FILE)
72	  try:
73	    lock_file = os.open(lock_filename,
74	                        os.O_CREAT | os.O_EXCL | os.O_TRUNC | os.O_RDWR)
75	  except OSError, err:
76	    print 'Failed to open lock file:\n  ' + str(err)
77	    return 1
78	
79	  # Write the pid of this script (the python.exe process) to the lock file.
80	  os.write(lock_file, str(os.getpid()))
81	
82	  options.target = options.target.title()
83	
84	  start_time = time.time()
85	
86	  print 'Change directory to ' + CHROMIUM_SOURCE_DIR
87	  os.chdir(CHROMIUM_SOURCE_DIR)
88	
89	  cmd = 'gclient sync'
90	  _RunCommand(cmd, options.dry_run, shell=True)
91	  print 'Elapsed time: %ds' % (time.time() - start_time)
92	
93	  # Do a clean build.  Remove the build output directory first.
94	  # TODO(wtc): Consider using Python's rmtree function in the shutil module,
95	  # or the RemoveDirectory function in
96	  # trunk/tools/buildbot/scripts/common/chromium_utils.py.
97	  cmd = 'rmdir /s /q %s\\%s\\%s' % (CHROMIUM_SOURCE_DIR,
98	                                    CHROMIUM_SOLUTION_DIR, options.target)
99	  _RunCommand(cmd, options.dry_run, shell=True)
100	  print 'Elapsed time: %ds' % (time.time() - start_time)
101	
102	  cmd = '%s\\cov-build.exe --dir %s devenv.com %s\\%s /build %s' % (
103	      COVERITY_BIN_DIR, COVERITY_INTERMEDIATE_DIR, CHROMIUM_SOURCE_DIR,
104	      CHROMIUM_SOLUTION_FILE, options.target)
105	  _RunCommand(cmd, options.dry_run)
106	  print 'Elapsed time: %ds' % (time.time() - start_time)
107	
108	  cmd = '%s\\cov-analyze.exe --dir %s %s' % (COVERITY_BIN_DIR,
109	                                             COVERITY_INTERMEDIATE_DIR,
110	                                             COVERITY_ANALYZE_OPTIONS)
111	  _RunCommand(cmd, options.dry_run)
112	  print 'Elapsed time: %ds' % (time.time() - start_time)
113	
114	  cmd = ('%s\\cov-commit-defects.exe --dir %s --datadir %s --product %s '
115	         '--user %s') % (COVERITY_BIN_DIR, COVERITY_INTERMEDIATE_DIR,
116	                         COVERITY_DATABASE_DIR, COVERITY_PRODUCT,
117	                         COVERITY_USER)
118	  _RunCommand(cmd, options.dry_run)
119	
120	  print 'Total time: %ds' % (time.time() - start_time)
121	
122	  os.close(lock_file)
123	  os.remove(lock_filename)
124	
125	  return 0
126	
127	if '__main__' == __name__:
128	  option_parser = optparse.OptionParser()
129	  option_parser.add_option('', '--dry-run', action='store_true', default=False,
130	                           help='print but don\'t run the commands')
131	  option_parser.add_option('', '--target', default='Release',
132	                           help='build target (Debug or Release)')
133	  options, args = option_parser.parse_args()
134	
135	  result = main(options, args)
136	  sys.exit(result)