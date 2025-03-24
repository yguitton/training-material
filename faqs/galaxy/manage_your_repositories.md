---
title: How do I manage my repositories on Galaxy?
area: features
layout: faq
box_type: tip
contributors: [dadrasarmin]
---

Here, we are going to briefly explain how you can Bring-Your-Own-Data to Galaxy or export your dataset, results, history, or workflows to 3rd party repositories. In order to add a new repository to your account follow these steps:

- Click on your Username on top right part of the website and then click on `Preferences`.
- From the middle panel, click on the `Manage your repositories` (previously `Manage your remote file sources`).
- Click on the `+ Create` button on top of the page. Here, you get multiple options to connect various repositories to your account.

{% include _includes/cyoa-choices.html option1="Onedata" option2="Amazon Web Services Private Bucket" option3="Amazon Web Services Public Bucket" option4="Azure Blob" option5="Dropbox" option6="eLabFTW" option7="An FTP Server" option8="Export to Google Drive" option9="InvenioRDM" option10="S3 Compatible Storage with Credentials" option11="WebDAV" option12="Zenodo" default="WebDAV" text="Select the repository you like to add to your Galaxy account." disambiguation="BYOD" %}

<div class="Onedata" markdown="1">
- Add Onedata
- Text
- Here
- Please!
</div>
<div class="Amazon-Web-Services-Private-Bucket" markdown="1">
- Add Amazon-Web-Services-Private-Bucket
- Text
- Here
- Please!
</div>
<div class="Amazon-Web-Services-Public-Bucket" markdown="1">
- Add Amazon-Web-Services-Public-Bucket
- Text
- Here
- Please!
</div>
<div class="Azure-Blob" markdown="1">
- Add Azure-Blob
- Text
- Here
- Please!
</div>
<div class="Dropbox" markdown="1">
- Click on the `Select` button in the `Dropbox` section.
- You will be redirected to the Dropbox website for authentication. You have to login there and grant access for the Galaxy.
- When you grant the access, you will be back on the Galaxy website. Here, you should give a "name" to your repository.
- Optionally, you can give this repository a description as well.
</div>
<div class="eLabFTW" markdown="1">
- Add eLabFTW
- Text
- Here
- Please!
</div>
<div class="An-FTP-Server" markdown="1">
- Add An-FTP-Server
- Text
- Here
- Please!
</div>
<div class="Export-to-Google-Drive" markdown="1">
- Add Export-to-Google-Drive
- Text
- Here
- Please!
</div>
<div class="InvenioRDM" markdown="1">
- Add InvenioRDM
- Text
- Here
- Please!
</div>
<div class="S3-Compatible-Storage-with-Credentials" markdown="1">
- Add S3-Compatible-Storage-with-Credentials
- Text
- Here
- Please!
</div>
<div class="WebDAV" markdown="1">

> Using WebDAV you can connect various services that supports WebDAV protocol such as OwnCloud and NextCloud among others. The configuration of WebDAV is slightly variable from service to service but the general principles apply everywhere.

- Click on the `Select` button in the `WebDAV` section.
- Give a `Name` to this repository. Optionally, you can also provide a `Description` for it.    
- Provide the server address to this repository in the `Server Domain` field.
- In the `WebDAV server Path`, you have to provide the path on this server to WebDAV.
- In the `Username` field, you should write the username you use to login to this server.
- You can grant write access for this repository using the `Writable?` (set to `yes`) and therefore make it possible to export datasets, histories, or workflows to your connected repository.

> As an example, if I want to connect my nextCloud repository to my Galaxy account, I should login to my nextCloud server and find the information from `File settings` (bottom left of the page) under the WebDAV section to fill this template. It could be something like: `https://server_address.com/remote.php/dav/files/username_or_text`. Then, `Server Domain` is `https://server_address.com` and `WebDAV server Path` is `remote.php/dav/files/username_or_text`.

In some cases, you may need to activate some features on your ownCloud or nextCloud to allow this integration. For example, some nextCloud servers require the user to use "App Passwords". This can be done using the `Settings > Security > Devices & sessions > Create new app password`.
</div>
<div class="Zenodo" markdown="1">
- Add Zenodo
- Text
- Here
- Please!
</div>
