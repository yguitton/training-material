---
layout: tutorial_hands_on

title: "Configuring the Onedata integration (remotes, Object Store, BYOS, BYOD)"
subtopic: data
tags:
  - storage
contributors:
  - lopiola

time_estimation: "30m"
level: Intermediate

requirements:
 - type: "internal"
   topic_name: galaxy-interface
   tutorials:
     - onedata-getting-started

questions:
- FIXME?
- FIXME?
objectives:
- FIXME
key_points:
- FIXME.
- FIXME.
---

<!-- FIXME convert tips to {: .tip} -->

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

This tutorial will walk you through the configuration of Onedata
connectors for Galaxy:

1. [Generic Remote File Source](#generic-remote-file-source) - FIXME short description.
2. [Specific Remote File Source](#specific-remote-file-source) - FIXME short description.
3. [BYOD (Remote File Source) templates](#byod-remote-file-source-templates) - FIXME short description.
4. [Object Store](#object-store) - FIXME short description.
5. [BYOS (Storage Location) templates](#byos-storage-location-templates) - FIXME short description.


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

Tip: if you are using Ansible, put the config in
`templates/galaxy/config/file_sources_conf.yml.j2`, like it has been done
[here](https://github.com/usegalaxy-eu/infrastructure-playbook/blob/master/templates/galaxy/config/file_sources_conf.yml.j2).


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

Tip: for Ansible, use the config file at `files/galaxy/config/user_preferences_extra_conf.yml`.  
See an example
[here](https://github.com/usegalaxy-eu/infrastructure-playbook/blob/master/files/galaxy/config/user_preferences_extra_conf.yml).


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

Tip: for Ansible, use the group vars file at `group_vars/gxconfig.yml`. See an example
[here](https://github.com/usegalaxy-eu/infrastructure-playbook/blob/master/group_vars/gxconfig.yml).


Add `fs.onedatarestfs` to `lib/galaxy/dependencies/pinned-requirements.txt`. Preferably,
copy the relevant line from `lib/galaxy/dependencies/conditional-requirements.txt` for the
newest version:
```
fs.onedatarestfs==21.2.5.2  # type: onedata, depends on onedatafilerestclient
```

Tip: skip this step if using Ansible — conditional requirements are then collected
automatically.


# Specific Remote File Source

FIXME the same as generic, but put down specific values.
FIXME typical use case is for readonly, public repositories.
```yaml
- type: onedata
  id: gtn_public_onedata
  label: GTN training data
  doc: Training data from the Galaxy Training Network (powered by Onedata)
  # The access Token is public and can be shared
  access_token: "MDAxY2xvY2F00aW9uIGRhdGFodWIuZWdpLmV1CjAwNmJpZGVudGlmaWVyIDIvbm1kL3Vzci00yNmI4ZTZiMDlkNDdjNGFkN2E3NTU00YzgzOGE3MjgyY2NoNTNhNS9hY3QvMGJiZmY1NWU4NDRiMWJjZGEwNmFlODViM2JmYmRhNjRjaDU00YjYKMDAxNmNpZCBkYXRhLnJlYWRvbmx5CjAwNDljaWQgZGF00YS5wYXRoID00gTHpaa1pUTTROMkl4WmpjMllXVmpOMlU00WWpreU5XWmtNV00ZpT1RKbU1ETXlZMmhoWTJReAowMDJmc2lnbmF00dXJlIIQvnXp01Oey02LnaNwEkFJAyArzhHN8SlXSYFsBbSkqdqCg"
  onezone_domain: "datahub.egi.eu"
```


# BYOD (Remote File Source) templates

FIXME how to configure the templates for a Onedata Remote File Source.
FIXME link to the guide on how to use them as a user.
FIXME materials: https://github.com/galaxyproject/galaxy/pull/18457


# Object Store

FIXME how to set up Onedata Object Store as the one used globally
for all users.
FIXME materials: https://github.com/galaxyproject/galaxy/pull/17540


# BYOS (Storage Location) templates

FIXME how to configure the templates for a Onedata Storage Location.
FIXME link to the guide on how to use them as a user.
FIXME materials: https://github.com/galaxyproject/galaxy/pull/18457
