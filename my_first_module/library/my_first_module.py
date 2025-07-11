#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

# Основная документация (где показана?)
DOCUMENTATION = r'''
---
module: my_first_module
short_description: Creates .tar or .tar.gz archive.
version_added: "1.0.0"
description: Archives a directory at specified path into .tar or .tar.gz format.
author:
  - Daniel (@yourGitHubHandle)
options:
  path:
    description:
      - Absolute path to the directory to archive.
      - The archive will be created in the same directory.
    required: true
    type: str
  gzip:
    description:
      - Enable gzip compression for the archive.
      - When true, creates .tar.gz instead of .tar.
    required: false
    type: bool
    default: false
'''
# Примеры использования
EXAMPLES = r'''
- name: Archive directory as .tar
  my_first_module:
    path: /some/path

- name: Archive directory with gzip compression
  my_first_module:
    path: /some/path
    gzip: true

- name: Fail if directory doesn't exist
  my_first_module:
    path: /nonexistent/path
'''
# Примеры возможных возвращаемых значений
RETURN = r'''
original_path:
  description: Original directory path that was archived.
  type: str
  returned: always
  sample: "/some/path"
archive_path:
  description: Full path to the created archive file.
  type: str
  returned: always
  sample: "/some/path.tar"
gzip_used:
  description: Indicates whether gzip compression was applied.
  type: bool
  returned: always
  sample: false
'''

from ansible.module_utils.basic import AnsibleModule
import os
import tarfile

# Основная функция
def run_module():
    # Определение доступных параметров
    module_args = dict(
        path=dict(type='str', required=True),
        gzip=dict(type='bool', required=False, default=False),
    )
    
    # Инициализируем объект модуля Ansible
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # Записывает результат в словарь. Наиболее важны changed и state.
    result = dict(
        changed=False,
        original_path=module.params['path'],
        archive_path='',
        gzip_used=module.params['gzip']
    )

    # Если во время исполнения произошло исключение или не соблюдено условие,
    # Запускает AnsibleModule.fail_json() и передает сообщение с результатом
    if not os.path.exists(module.params['path']):
        module.fail_json(msg=f"Path {module.params['path']} does not exist", **{
            'changed': False,
            'failed': True
        })

    # Есть модуль запущен в режиме проверки, мы ничего не меняем
    # Только возвращаем текущее состояние
    if module.check_mode:
        module.exit_json(**result)

    # Формирование имени архива
    base_name = os.path.basename(module.params['path'])
    ext = '.tar.gz' if module.params['gzip'] else '.tar'
    archive_path = os.path.join(
        os.path.dirname(os.path.abspath(module.params['path'])),
        f"{base_name}{ext}"
    )
    result['archive_path'] = archive_path

    # Создание архива
    try:
        mode = 'w:gz' if module.params['gzip'] else 'w'
        with tarfile.open(archive_path, mode) as tar:
            tar.add(module.params['path'], arcname=base_name)
        result['changed'] = True
    except Exception as e:
        module.fail_json(msg=f"Failed to create archive: {str(e)}", **result)

    # Если исполнение прошло успешно, возвращает AnsibleModule.exit_json() вместе с результатом
    module.exit_json(**result)

# Главная фунция запускает основную
def main():
    run_module()

if __name__ == '__main__':
    main()