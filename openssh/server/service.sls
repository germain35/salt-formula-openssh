{%- from "openssh/map.jinja" import openssh with context %}

include:
  - openssh.install

{%- if openssh.server.banner is defined %}

/etc/banner:
  file.managed:
  - user: root
  - group: root
  - source: salt://openssh/files/banner
  - mode: 644
  - template: jinja
  - require:
    - pkg: openssh_packages
  - watch_in:
    - service: openssh_server_service

{%- endif %}

openssh_server_config:
  file.managed:
  - name: {{ openssh.server.config }}
  - user: root
  - group: root
  - source: salt://openssh/files/sshd_config
  - mode: 600
  - template: jinja
  - require:
    - pkg: openssh_packages

openssh_server_service:
  service.running:
  - name: {{ openssh.server.service }}
  - enable: {{ openssh.server.service_enabled }}
  - watch:
    - file: openssh_server_config
