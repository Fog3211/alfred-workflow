const alfy = require('alfy')
const RandExp = require('randexp')

const PASSWORD_MODE_REGEXP_CONFIG = [{
    key: 'ONLY_NUMBER',
    label: '纯数字',
    value: '[0-9]'
  },
  {
    key: 'ONLY_CHAR',
    label: '纯字母',
    value: '[a-zA-Z]'
  },
  {
    key: 'ONLY_LOWER_CHAR',
    label: '全小写字母',
    value: '[a-z]'
  },
  {
    key: 'ONLY_UPER_CHAR',
    label: '全大写字母',
    value: '[A-Z]'
  },
  {
    key: 'CHAR_AND_NUMBER',
    label: '数字+字母组合',
    value: '[0-9a-zA-Z]'
  },
  {
    key: 'ANY_CHAR',
    label: '任意字符',
    value: '[0-9a-zA-Z=_@!#%&-\+\*\/\^\$]'
  },
]
const DEFAULT_PWD_LEN = 9
const input_len = Number(process.argv[2]) || 0
const pwd_len = input_len >= 1 ? input_len : DEFAULT_PWD_LEN

const items = PASSWORD_MODE_REGEXP_CONFIG.map(item => {
  const record = new RandExp(`${item.value}{${pwd_len}}`).gen()
  return {
    title: record,
    subtitle: item.label,
    text: {
      copy: record,
    },
    arg: record
  }
})

alfy.output(items);
