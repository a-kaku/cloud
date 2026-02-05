[sssd]
domains = hgs.h21group.com
config_file_version = 2
services = nss, pam

[domain/hgs.h21group.com]
default_shell = /bin/bash
krb5_store_password_if_offline = True
cache_credentials = True
krb5_realm = HGS.H21GROUP.COM
realmd_tags = manages-system joined-with-adcli
id_provider = ad
ad_domain = hgs.h21group.com
use_fully_qualified_names = false
ldap_id_mapping = True
access_provider = ad
ldap_group_nesting_level = 1
ldap_sasl_mech = GSSAPI

fallback_homedir = /srv/efs/
default_shell = /sbin/nologin