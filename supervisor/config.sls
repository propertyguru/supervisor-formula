# -*- coding: utf-8 -*-
# vim: ft=sls

{% set environment = salt['pillar.get']('environment','dev') -%}

{%- if environment in ['sandbox', 'dev'] -%}
{% set devbox_name = salt['grains.get']('id') | replace('.guruestate.com','') | replace('dev-','')  | replace('sandbox-','') -%}
{%- else -%}
{% set devbox_name = '' -%}
{%- endif -%}

# Hack to set env as prod. Remove this below 3 lines when we remove prod as environment variable
{%- if environment == 'production' -%}
{%- set environment = 'prod' -%}
{%- endif -%}


{% from "supervisor/map.jinja" import supervisor with context %}

supervisor-config:
  file.managed:
    - name: {{ supervisor.config }}
    - source: salt://supervisor/templates/supervisord.conf.tmpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - require_in:
      - service: supervisor.service
    - watch_in:
      - service: supervisor.service

{% if 'programs' in supervisor %}
{% for program,values in supervisor.programs.items() %}
supervisor-program-{{ program }}:
{% if ( 'enabled' in values and values.enabled ) or 'enabled' not in values %}
  file.managed:
{% if 'legacy' in supervisor and supervisor.legacy %}
    - name: {{ supervisor.program_dir }}/{{ program }}-prog.conf
{% else %}
    - name: {{ supervisor.program_dir }}/{{ program }}.conf
{% endif %}
    - source: salt://supervisor/templates/program.conf.tmpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - defaults:
        program: {{ program }}
        values: {{ values }}
        environment: {{ environment }}
        sub_env: {{ devbox_name }}
    - watch_in:
      - service: supervisor.service
{% elif 'enabled' in values and not values.enabled %}
  file.absent:
{% if 'legacy' in supervisor and supervisor.legacy %}
    - name: {{ supervisor.program_dir }}/{{ program }}-prog.conf
{% else %}
    - name: {{ supervisor.program_dir }}/{{ program }}.conf
{% endif %}
    - watch_in:
        - service: supervisor.service
{% endif %}

{% endfor %}
{% endif %}

