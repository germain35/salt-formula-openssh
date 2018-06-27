{%- from "openssh/map.jinja" import openssh with context %}

openssh_packages:
  pkg.installed:
    - pkgs: {{ openssh.pkgs }}