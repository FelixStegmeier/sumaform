{% macro repl_in_container(key, value, file) -%}
        mgrctl exec 'grep -q "^{{ key }}.*$" {{ file }} &&
        sed -i "s/^{{ key }}.*/{{ key }} = {{ value }}/" {{ file }} ||
        echo "{{ key }} = {{ value }}" >> {{ file }}'
{%- endmacro %}

{% set file_path = "/etc/rhn/rhn.conf" %}

{% if grains.get('skip_changelog_import') %}
package_import_skip_changelog_reposync:
  cmd.run:
    - name: |
        {{ repl_in_container("package_import_skip_changelog", 1, file_path) }}
{% endif %}

limit_changelog_entries:
  cmd.run:
    - name: |
        {{ repl_in_container("java.max_changelog_entries", 3, file_path) }}

{% if grains.get('disable_download_tokens') %}
disable_download_tokens:
  cmd.run:
    - name: |
        {{ repl_in_container("java.salt_check_download_tokens", false, file_path) }}
{% endif %}

{% if grains.get('monitored') | default(false, true) %}
rhn_conf_prometheus:
  cmd.run:
    - name: |
        {{ repl_in_container("prometheus_monitoring_enabled", true, file_path) }}
{% endif %}

{% if not grains.get('forward_registration') | default(false, true) %}
rhn_conf_forward_reg:
  cmd.run:
    - name: |
        {{ repl_in_container("server.susemanager.forward_registration", 0, file_path) }}
{% endif %}

{% if grains.get('auto_bootstrap') == false | default(true, true) %}
rhn_conf_disable_auto_generate_bootstrap_repo:
  cmd.run:
    - name: |
        {{ repl_in_container("server.susemanager.auto_generate_bootstrap_repo", 0, file_path) }}
{% endif %}

{% if 'head' in grains.get('product_version', '') and grains.get('beta_enabled') %}
change_product_tree_to_beta:
  cmd.run:
    - name: |
        {{ repl_in_container("java.product_tree_tag", 0, file_path) }}
{% endif %}

{% if grains.get('testsuite') | default(false, true) %}
increase_presence_ping_timeout:
  cmd.run:
    - name: |
        {{ repl_in_container("java.salt_presence_ping_timeout", 6, file_path) }}
{% endif %}

# see https://documentation.suse.com/multi-linux-manager/5.1/en/docs/administration/auditing.html#_oval
{% if grains.get('enable_oval_metadata') | default(false, true) %}
oval_metadata_enable_synchronization:
  cmd.run:
    - name: |
        {{ repl_in_container("java.cve_audit.enable_oval_metadata", true, file_path) }}

oval_metadata_services_restart:
  cmd.run:
    - name: mgrctl exec systemctl restart tomcat taskomatic
    - watch:
      - cmd: oval_metadata_enable_synchronization
{% endif %}

{% if 'nightly' in grains.get('product_version', '') %}
change_web_version:
  cmd.run:
    - name: |
        PRODUCT_VERSION=$(mgrctl exec "cat /etc/susemanager-release | awk -F'[()]' '{print \$2}'")
        BUILD_DATE=$(date +%Y%m%d)
        FULL_VERSION="${PRODUCT_VERSION}.${BUILD_DATE}"
        {{ repl_in_container("web.version", ${FULL_VERSION}, file_path) }}
{% endif %}

rhn_conf_present:
  cmd.run:
    - name: mgrctl exec 'touch {{ file_path }}'

