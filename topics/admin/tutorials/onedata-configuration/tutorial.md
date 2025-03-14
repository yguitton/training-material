---
layout: tutorial_hands_on

title: "Configuring the Onedata integration (remotes, Object Store, BYOS, BYOD)"
subtopic: data
tags:
  - storage
contributors:
  - lopiola
time_estimation: "1h"
level: Intermediate

requirements:
 - type: "internal"
   topic_name: admin
   tutorials:
     - onedata-getting-started
     - ansible
     - ansible-galaxy

questions:
- How to configure different types of Onedata integration in Galaxy?
- What are the differences between various Onedata configurations?
- How to enable users to bring their own data and storage?
objectives:
- Configure Generic and Specific Remote File Sources
- Set up Onedata as an Object Store
- Enable BYOD and BYOS templates for users
key_points:
- Galaxy supports four types of Onedata integration: Generic/Specific Remote File Sources and global/user Object Stores
- BYOD and BYOS templates allow users to configure their own data sources and storage locations
- Vault configuration is required for user-managed credentials
---

> <agenda-title></agenda-title>
>
> 1. TOC
> {:toc}
>
{: .agenda}


# Prerequisites

Its recommended that you have basic knowledge about Onedata and access 
to a Onedata ecosystem, so that you can test the configuration. If needed, follow 
[this tutorial]({% link topics/galaxy-interface/tutorials/onedata-getting-started/tutorial.html %})
first!


# Introduction

This tutorial will walk you through the configuration of five different types of Onedata 
integration with Galaxy:

1. [Generic Remote File Source](#generic-remote-file-source) - Allows users to configure their 
own Onedata connection through user preferences, enabling them to import data from and export data 
to their Onedata spaces.

2. [Specific Remote File Source](#specific-remote-file-source) - Provides all users with access to 
a predefined Onedata space (e.g., for shared training datasets) without requiring individual 
configuration.

3. [BYOD (Remote File Source) templates](#byod-remote-file-source-templates) - Similar to 
Generic Remote File Source, but uses templates and vault for secure credential storage, 
allowing users to configure multiple Onedata connections.

4. [Object Store](#object-store) - Configures Onedata as Galaxy's global storage backend, 
where all datasets are stored in a specified Onedata space.

5. [BYOS (Storage Location) templates](#byos-storage-location-templates) - Enables users to 
configure their own Onedata spaces as storage locations for their Galaxy datasets.


# Common Configuration

Before configuring specific Onedata integrations, there are a few common elements that need to be set up:

## Dependencies

For Remote File Sources (Generic, Specific, and templates), add `fs.onedatarestfs` 
to `lib/galaxy/dependencies/pinned-requirements.txt`. Copy the relevant line from 
`lib/galaxy/dependencies/conditional-requirements.txt` for the newest version:
```
fs.onedatarestfs==21.2.5.2  # type: onedata, depends on onedatafilerestclient
```

For Object Store configuration, only `onedatafilerestclient` is required. However, 
if you're already installing `fs.onedatarestfs` for Remote File Sources, you don't 
need to add it separately as it's included as a dependency.

If you're only using Object Store functionality, you can add just:
```
onedatafilerestclient
```

> <tip-title>Using Ansible</tip-title>
> Skip this step if using Ansible — conditional requirements are collected automatically.
{: .tip}

## Vault Configuration

FIXME: czy jest tutorial o vault?

For BYOD and BYOS templates, you need to configure a vault to securely store user credentials:

1. Create `config/vault_conf.yml`:
```yaml
type: database
path_prefix: /galaxy
# Encryption keys must be valid fernet keys
# Generate them using Python:
# from cryptography.fernet import Fernet
# Fernet.generate_key().decode('utf-8')
encryption_keys:
  - KpVfbD7WfsNMxEnAEasql9aqSc1eCqR-S-tJCDyzcw8=
  - s1DDUEjZtFy2xknGIW2AiAE6EiZG5xSD0m_GzXi43G0=
  - qyb7f45l4XdkcuC5y06RlWtaENcPtUgHYekoQJBK1zM=
```

The first key is used for encryption, while additional keys allow for key rotation. 

2. Enable it in `config/galaxy.yml`:
```yaml
galaxy:
  vault_config_file: vault_conf.yml
```

For more details about vault configuration, see the [Galaxy Vault documentation](https://docs.galaxyproject.org/en/latest/admin/special_topics/vault.html).


# Generic Remote File Source

Make sure there is a `config/file_sources_conf.yml` configuration file with Onedata
section. The relevant snippet can be found in config
[samples](https://github.com/galaxyproject/galaxy/blob/dev/lib/galaxy/config/sample/file_sources_conf.yml.sample).
At the time of writing this tutorial, the config looks like the following:
```yaml
- type: onedata
  id: onedata1
  label: Onedata
  doc: Your Onedata files - configure an access token via user preferences
  access_token: ${user.preferences['onedata|access_token']}
  onezone_domain: ${user.preferences['onedata|onezone_domain']}
  disable_tls_certificate_validation: ${user.preferences['onedata|disable_tls_certificate_validation']}
  writable: true
```

> <tip-title>Using Ansible</tip-title>
> If you are using Ansible, put the config in `templates/galaxy/config/file_sources_conf.yml.j2`, 
> like it has been done [here](https://github.com/usegalaxy-eu/infrastructure-playbook/blob/master/templates/galaxy/config/file_sources_conf.yml.j2).
{: .tip}


Do the same for the user preferences config: `config/user_preferences_extra_conf.yml`. A
sample can be found
[here](https://github.com/galaxyproject/galaxy/blob/dev/lib/galaxy/config/sample/user_preferences_extra_conf.yml.sample).
```yaml
preferences:
    ...

    # Used in file_sources_conf.yml
    onedata:
        description: Your Onedata account
        inputs:
            - name: onezone_domain
              label: Domain of the Onezone service (e.g. datahub.egi.eu). The minimal supported Onezone version is 21.02.4.
              type: text
              required: False
            - name: access_token
              label: Your access token, suitable for REST API access in a Oneprovider service
              type: password
              required: False
            - name: disable_tls_certificate_validation
              label: Allow connection to Onedata servers that do not present trusted SSL certificates. SHOULD NOT be used unless you really know what you are doing.
              type: boolean
              required: False
              value: False
```

> <tip-title>Using Ansible</tip-title>
> For Ansible, use the config file at `files/galaxy/config/user_preferences_extra_conf.yml`. 
> See an example [here](https://github.com/usegalaxy-eu/infrastructure-playbook/blob/master/files/galaxy/config/user_preferences_extra_conf.yml).
{: .tip}


Ensure there is the main galaxy config file (`config/galaxy.yml`) and it includes the two
configs above:
```yaml
galaxy:
  ...
  file_sources_config_file: file_sources_conf.yml
  ...
  user_preferences_extra_conf_path: user_preferences_extra_conf.yml
  ...
```

> <tip-title>Using Ansible</tip-title>
> For Ansible, use the group vars file at `group_vars/gxconfig.yml`. 
> See an example [here](https://github.com/usegalaxy-eu/infrastructure-playbook/blob/master/group_vars/gxconfig.yml).
{: .tip}

For required dependencies, see the [Dependencies section](#common-configuration-dependencies) in Common Configuration.


# Specific Remote File Source

While the [Generic Remote File Source](#generic-remote-file-source) allows users to configure 
their own Onedata access credentials through user preferences, you can also set up a specific 
Onedata File Source that will be available to all users with predefined access parameters.

This approach is particularly useful when you want to provide access to shared resources, 
such as public training datasets, without requiring users to configure their own Onedata credentials.

Example configuration in `config/file_sources_conf.yml`:

```yaml
- type: onedata
  id: gtn_public_onedata
  label: GTN training data
  doc: Training data from the Galaxy Training Network (powered by Onedata)
  # The access token is public and can be shared
  access_token: "MDAxY2xvY2F00aW9uIGRhdGFodWIuZWdpLmV1CjAwNmJpZGVudGlmaWVyIDIvbm1kL3Vzci00yNmI4ZTZiMDlkNDdjNGFkN2E3NTU00YzgzOGE3MjgyY2NoNTNhNS9hY3QvMGJiZmY1NWU4NDRiMWJjZGEwNmFlODViM2JmYmRhNjRjaDU00YjYKMDAxNmNpZCBkYXRhLnJlYWRvbmx5CjAwNDljaWQgZGF00YS5wYXRoID00gTHpaa1pUTTROMkl4WmpjMllXVmpOMlU00WWpreU5XWmtNV00ZpT1RKbU1ETXlZMmhoWTJReAowMDJmc2lnbmF00dXJlIIQvnXp01Oey02LnaNwEkFJAyArzhHN8SlXSYFsBbSkqdqCg"
  onezone_domain: "datahub.egi.eu"
  writable: false
```

Note that you don't need to configure `user_preferences_extra_conf.yml` in this case, as all access parameters are specified directly in the File Sources configuration.


# BYOD (Remote File Source) templates

BYOD (Bring Your Own Data) allows users to configure their own Onedata File Sources using templates. 
This feature requires a vault for secure credential storage, but instead of configuring File Sources 
through user preferences (as in [Generic Remote File Source](#generic-remote-file-source)), 
users can create multiple File Sources with different configurations.

1. Configure the vault as described in the [Vault Configuration section](#common-configuration-vault-configuration).

2. Enable the Onedata template by creating or modifying `config/file_source_templates.yml`:

```yaml
- include: ./lib/galaxy/files/templates/examples/onedata.yml
```

This template defines a form that users will see when creating their own Onedata File Source. 
It collects the same configuration parameters that administrators specify when setting up 
a [Specific Remote File Source](#specific-remote-file-source) (like Onezone domain, access token, 
etc.), but allows users to provide their own values.

FIXME: wygląda na to, że w jinja to już jest https://github.com/usegalaxy-eu/infrastructure-playbook/blob/master/templates/galaxy/config/file_source_templates.yml.j2 - pisać o tym?

For required dependencies, see the [Dependencies section](#common-configuration-dependencies) in Common Configuration.

For detailed instructions on how users can create and use their File Sources, refer to the 
[user documentation]({% link topics/galaxy-interface/tutorials/onedata-remote-import/tutorial.html %}).


# Object Store

Galaxy supports various object store backends for storing datasets. While the [Object Store tutorial]({% link topics/admin/tutorials/object-store/tutorial.md %}) provides a comprehensive overview of the feature, this section focuses specifically on configuring Onedata as a global object store.

To use Onedata as your object store, you need to:

1. Create the object store configuration in `config/object_store_conf.xml`:

```xml
<object_store type="onedata">
    <auth access_token="..." />
    <connection onezone_domain="..." disable_tls_certificate_validation="False"/>
    <space name="..." path="..." />
    <cache path="database/object_store_cache" size="1000" cache_updated_data="True" />
    <extra_dir type="job_work" path="database/job_working_directory_onedata"/>
    <extra_dir type="temp" path="database/tmp_onedata"/>
</object_store>
```

The configuration parameters are:
- `access_token`: An access token suitable for data access (allowing calls to the Oneprovider REST API)
- `onezone_domain`: The domain of the Onezone service (e.g., datahub.egi.eu)
- `name`: The name of the Onedata space where the Galaxy data will be stored
- `path`: The relative directory path in the space under which the Galaxy data will be stored (optional, defaults to space root)

2. Enable the object store configuration in `config/galaxy.yml`:

```yaml
galaxy:
  ...
  object_store_config_file: object_store_conf.xml
```

> <warning-title>Switching object store types</warning-title>
> If you're switching from another object store type, you'll need to handle the migration of existing datasets. This process is not covered in this tutorial and should be carefully planned for production instances.
{: .warning}

For required dependencies, see the [Dependencies section](#common-configuration-dependencies) 
in Common Configuration.

For more details about object store configuration options and best practices, see the [Object Store tutorial]({% link topics/admin/tutorials/object-store/tutorial.md %}).

FIXME: wzmianka o jinja?


# BYOS (Storage Location) templates

BYOS (Bring Your Own Storage) allows users to configure their own Onedata Storage Locations using templates. Similar to [BYOD](#byod-remote-file-source-templates), this feature requires a vault for secure credential storage, but instead of configuring File Sources, users can set up their own Object Store locations.

1. Configure the vault as described in the [Vault Configuration section](#common-configuration-vault-configuration).

2. Enable the Onedata template by creating or modifying `config/object_store_templates.yml`:

```yaml
- include: ./lib/galaxy/objectstore/templates/examples/onedata.yml
```

This template provides users with a form to configure their Onedata Storage Location, collecting information such as:
- Onezone domain and access token
- Space name and path for storing datasets
- Cache and performance settings

> <warning-title>Write access required</warning-title>
> BYOS configurations require write access to the Onedata space, as Galaxy will be storing datasets there.
{: .warning}

For required dependencies, see the [Dependencies section](#common-configuration-dependencies) 
in Common Configuration.

For detailed instructions on how users can create and use Storage Locations, refer to the [user documentation]({% link topics/galaxy-interface/tutorials/onedata-byos/tutorial.html %}).

FIXME: wzmianka o jinja?
