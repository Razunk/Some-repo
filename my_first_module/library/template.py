#!/usr/bin/python

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
module: <НАЗВАНИЕ>
short_description: <КОРОТКОЕ ОПИСАНИЕ>
version_added: "1.0.0"
description: <ДЛИННОЕ ОПИСАНИЕ>
author:
  - Daniel (@yourGitHubHandle)
options:
  <ОДНА ИЗ ОПЦИЙ>:
    description:
      - <ОПИСАНИЕ ЭТОЙ ОПЦИИ>
    required: true (ОБЯЗАТЕЛЬНА ЛИ ОНА)
    type: str (КАКОЙ ТИП)
'''

EXAMPLES = r'''
<ПРИМЕР ИСПОЛЬЗОВАНИЯ TASK>
'''

RETURN = r'''
<ОДНО ИЗ ВОЗВРАЩАЕМЫХ ЗНАЧЕНИЙ>:
  description: <ОПИСАНИЕ>
  type: str (КАКОЙ ТИП)
  returned: always (УСЛОВИЕ ВОЗВРАТА)
  sample: <ПРИМЕР ВОЗВРАТА>
'''

from ansible.module_utils.basic import AnsibleModule
# ВСЕ НУЖНЫЕ БИБЛИОТЕКИ
# ПОРЯДОК ВАЖЕН!
# Основная функция
def run_module():
    # Определение доступных параметров
    module_args = dict(
        some_paramether=dict(type='str', required=True, default="..")
    )
    
    # Инициализируем объект модуля Ansible
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # Записывает результат в словарь. Наиболее важны changed и state.
    result = dict(
        changed=False,
        #<ОДНО ИЗ ВОЗВРАЩАЕМЫХ ЗНАЧЕНИЙ>=его значение. НАПРИМЕР original_path=module.params['path'],
    )

    # Если во время исполнения произошло исключение или не соблюдено условие,
    # Запускает AnsibleModule.fail_json() и передает сообщение с результатом
    if not ...:
        module.fail_json(msg=f"Какое-то соообщение", **{
            'changed': False,
            'failed': True
        })

    # Есть модуль запущен в режиме проверки, мы ничего не меняем
    # Только возвращаем текущее состояние
    if module.check_mode:
        module.exit_json(**result)

    # Основной код модуля тут!

    # Если исполнение прошло успешно, возвращает AnsibleModule.exit_json() вместе с результатом
    module.exit_json(**result)

# Главная фунция запускает основную
def main():
    run_module()

if __name__ == '__main__':
    main()