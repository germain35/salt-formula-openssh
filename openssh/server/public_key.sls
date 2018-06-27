{%- from "openssh/map.jinja" import openssh with context %}

{%- for user, params in openssh.server.get('user', {}).items() %}

{%- if user.public_keys is defined %}

{{ user }}_ssh_dir:
  file.directory:
  - name: {{ params.home }}/.ssh
  - user: {{ user }}
  - group: {{ user }}
  - mode: 700

{%- if user.get('purge', False) %}

{{ user }}_auth_keys:
  file.managed:
  - name: {{ params.home }}/.ssh/authorized_keys
  - user: {{ user }}
  - group: {{ params.get('group', user) }}
  - mode: 600
  - template: jinja
  - source: salt://openssh/files/authorized_keys
  - require:
    - file: {{ user }}_ssh_dir
  - defaults:
      user_name: {{ user }}

{%- else %}

{{ user }}_auth_keys:
  ssh_auth.present:
  - user: {{ user }}
  - names:
    {%- for public_key in user.public_keys %}
    - {{ public_key.key }}
    {%- endfor %}
  - require:
    - file: {{ user }}_ssh_dir

{%- endif %}

{%- else %}

{%- if user.get('purge', False) %}
{{ user }}_auth_keys:
  file.absent:
  - name: {{ params.home }}/.ssh/authorized_keys
{%- endif %}

{%- endif %}

{%- endfor %}
