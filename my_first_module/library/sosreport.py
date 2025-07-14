#!/usr/bin/python

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: sosreport
short_description: Runs sosreport to create and archive with system information.
version_added: "1.0.0"
description: Runs sosreport, a Linux diagnostic tool that collects system information and packages it into a compressed archive.
author:
  - Daniel (@yourGitHubHandle)
notes:
  - Supports only Astra Linux.
  - Requires root privileges or sudo access.
options:
  install:
    description:
      - Install 'sosreport' package if it's not found.
    required: false
    type: bool
    default: false
  case_id:
    description:
      - Attaches a case/ticket ID (e.g., for tracking with tech support).
    required: false
    type: str
  collect_logs:
    description:
      - Includes all log files, with rotated/archived logs.
    required: false
    type: bool
    default: false
'''

EXAMPLES = r'''
- name: Install package and collect system information
  sosreport:
    install: true

- name: Collect system information with all logs, attached a case/ticket ID
  sosreport:
    case_id: SIRIUS-966107
    collect_logs: true
'''

RETURN = r'''
archive_path:
  description: Full path to the created archive file.
  type: str
  returned: always
  sample: "/some/path.tar.gz"
'''
from ansible.module_utils.basic import AnsibleModule
import glob
import os
import re

def check_sosreport_installed(module):
    return module.get_bin_path('sosreport') is not None

def install_sosreport(module):
    module.run_command("apt-get update", check_rc=True)
    rc, _, err = module.run_command("apt-get install -y sosreport", check_rc=False)
    if rc != 0:
        module.fail_json(msg=f"Ошибка установки после обновления индекса: {err}")

def run_sosreport(module, case_id, collect_logs):
    
    if case_id and not re.match(r'^[a-zA-Z0-9_-]+$', case_id):
        module.fail_json(msg="Invalid case_id. Only alphanumeric chars, '-' and '_' are allowed")

    cmd = ["sosreport", "-a", "--batch"]
    if case_id:
        cmd.extend(["--case-id", case_id])
    if collect_logs:
        cmd.append("--all-logs")

    if module.check_mode:
      module.exit_json(changed=True, msg=f"Would have run: {cmd}")
    
    rc, out, err = module.run_command(cmd, check_rc=False)
    if rc != 0:
        module.fail_json(msg=f"Failed to run sosreport: {err}")
    
    reports = glob.glob("/tmp/sosreport-*.tar.*z")
    if not reports:
        module.fail_json(msg="No sosreport archive found in /tmp")
    archive_path = sorted(reports, key=os.path.getmtime, reverse=True)[0]
    return archive_path

def run_module():
    module_args = dict(
        install=dict(type='bool', required=False, default=False),
        case_id=dict(type='str', required=False),
        collect_logs=dict(type='bool', required=False, default=False)
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    result = dict(
        changed=False,
        archive_path=''
    )

    if not check_sosreport_installed(module):
        if module.params['install']:
            if module.check_mode:
                result['changed'] = True
                result['msg'] = "Would have installed sosreport."
                module.exit_json(**result)
            else:
                install_sosreport(module)
                result['changed'] = True
        else:
            module.fail_json(msg="sosreport is not installed and install parameter is False")

    archive_path = run_sosreport(
        module,
        case_id=module.params['case_id'],
        collect_logs=module.params['collect_logs']
    )
    
    result['changed'] = True
    result['archive_path'] = archive_path

    module.exit_json(**result)

def main():
    run_module()

if __name__ == '__main__':
    main()