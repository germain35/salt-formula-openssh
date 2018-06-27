
{%- from "openssh/map.jinja" import openssh with context %}

include:
  - openssh.install
  {%- if openssh.server.get('enabled', False) %}
  - openssh.server
  {%- endif %}
  {%- if openssh.client.get('enabled', False) %}
  - openssh.client
  {%- endif %}
