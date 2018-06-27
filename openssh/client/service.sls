{%- from "openssh/map.jinja" import client with context %}

include:
  - openssh.install

openssh_client_config:
  file.managed:
  - name: {{ client.config }}
  - user: root
  - group: root
  - source: salt://openssh/files/ssh_config
  - mode: 644
  - template: jinja
  - require:
    - pkg: openssh_packages

{%- for user, params in client.get('user', {}).items() %}

{%- if user.get('enabled', True) %}

{{ params.home }}/.ssh:
  file.directory:
  - user: {{ params.name }}
  - mode: 700
  - makedirs: true
  - require:
    - pkg: openssh_packages

openssh_client_{{ user }}_config:
  file.managed:
  - name: {{ params.home }}/.ssh/config
  - user: {{ user }}
  - source: salt://openssh/files/ssh_config
  - mode: 600
  - template: jinja
  - require:
    - pkg: openssh_packages

{%- endif %}

{%- endfor %}
