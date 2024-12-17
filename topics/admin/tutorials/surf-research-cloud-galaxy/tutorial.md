---
layout: tutorial_hands_on

title: "Galaxy and Pulsar usage on SURF Research Cloud"
zenodo_link: ""
questions:
  - How do I start a Galaxy instance on SURF Research Cloud?
  - How do I link to external storage from my Galaxy workspace?
  - How do I install tools?
  - How do I connect to Pulsar?
objectives:
  - Understand how to work with a Galaxy on-demand instance in SURF Research Cloud
  - Be able to attach a Pulsar node to Galaxy and use interactive tools
requirements:
  - type: "none"
    title: Access to the SURF Research Cloud
  - type: "none"
    title: SRAM authentication
  - type: "none"
    title: An SSH key connected to your account
  - type: "none"
    title: Have a basic understanding of how Galaxy works 
time_estimation: "30m"
level: "beginner"
contributions:
  authorship:
  - mirelaminkova
  - hexylena
  - dometto

edam_ontology:
- topic_3489 # Database Management
- topic_0605 # Informatics
- topic_3071 # Data Management

abbreviations:
  SRC: SURF Research Cloud
  GDPR: General Data Protection Regulations
  SRAM: SURF Research Access Management
  CO: Collaborative Organisation
---

# Overview 
Using Galaxy via the SURF Research Cloud (SRC) allows researchers to start Galaxy instances on-demand and analyze their data in a secure environment following the General Data Protection Regulations (GDPR). The instance provides secure authentication, where users must have a SURF Research account prior to this tutorial, have set the SRAM authentication method, and connect an SSH key to their accounts. In case you are not familiar with SRC and need help in setting up your accounts, please follow the instructions on the [SURF Knowledge Base](https://servicedesk.surf.nl/wiki/display/WIKI/SURF+Research+Cloud)

In this training the aim is to focus on:

- Understanding how to start Galaxy on SRC
- Connecting the instance to the Pulsar catalog item
- Attaching external volumes for storage

Galaxy instances can be started and stopped on demand, depending on personal cases and requirements. Inside the SRC members should have access to all publically available catalog items. If you are not able to create a catalog item, please contact SURF servicedesk, servicedesk@surf.nl. 

# Prerequisites 
This tutorial assumes you are member of a collaboration in SRAM that has access to SRC and a wallet with budget in SRC with enough sources to create Galaxy and Pulsar catalog items. (For more information please refer to the [SURF Knowledge Base](https://servicedesk.surf.nl/wiki/display/WIKI/Budgets%2C+wallets%2C+contracts) You must have previous experience working with data inside Galaxy.

# Starting a Galaxy instance inside SCR step-by-step
## Access the SRC
The first and most important step is to have access to the SURF Research Cloud. Once you login to the [portal](https://portal.live.surfresearchcloud.nl). 
<img width="1472" alt="Screenshot 2024-12-11 at 08 51 59" src="https://github.com/user-attachments/assets/6207275f-9a25-41ca-89b6-4b7f3d043ae8" />
<img width="1479" alt="Screenshot 2024-12-10 at 16 14 45" src="https://github.com/user-attachments/assets/1e8dcd44-4001-4451-9ee9-8d5957714ac5" />
Log in with your institute credentials and follow the SRAM authentication on your phone. Inside the environment, you can see if there are any active virtual machines, the options to create a workspace, new storage or request new wallet for your projects. 
<img width="1479" alt="Screenshot 2024-12-10 at 15 40 25" src="https://github.com/user-attachments/assets/40e6f78c-070b-4a08-a02b-a9e947b6733a" />

## Create an external storage
The purpose of the storage is to attach it to your workspace, where you will save your data. This way, if the machine is deleted, your data will not be lost. We strongly advise anyone using the SRC to create storages and attach them to their machines!

Locate the “Create new storage” and click on “Create new”. Select the collaborative organisation you want the storage to be part of.
<img width="1484" alt="Screenshot 2024-12-11 at 09 31 22" src="https://github.com/user-attachments/assets/bf69d2ef-7bbd-4fb7-b829-d695f6a4d649" />

Select the desired cloud provider and the size of the volume you want to use. If you are unsure about the size of the storage you need, contact your administrator. 
<img width="1461" alt="Screenshot 2024-12-11 at 09 33 18" src="https://github.com/user-attachments/assets/d6f5956f-e30c-46b3-9559-92de7551c1ed" />

Name your storage however you like and press on submit.
<img width="1484" alt="Screenshot_2024-12-10_at_15 50 42" src="https://github.com/user-attachments/assets/b820cb59-aa23-44a4-ab71-831e4d708b67" />

You will be redirected to a the main page, where you will be able to track the status of the storage creation. 
<img width="1461" alt="Screenshot 2024-12-10 at 15 51 08" src="https://github.com/user-attachments/assets/e7b10b8c-600f-494b-b4cc-8c2d5a6d8384" />

Once the storage is deployed, you can attach it to any of your machines! 🎉 

Be aware, that in order to attach an external storage to an existing machine, you would need to pause the workspace first! (If you are not sure how to do that please refer to [External storage volumes](https://servicedesk.surf.nl/wiki/display/WIKI/External+storage+volumes))

# Create a new workspace
Depending on user’s rights, you can create a new workspace for your collaboration.

On the right side under the “Workspaces” click on the "Add" button.
<img width="1481" alt="Screenshot 2024-12-10 at 15 40 49" src="https://github.com/user-attachments/assets/f59a4d2f-5141-4a20-a5cd-96c2b49c7d25" />

Then, you will be redirected to a new page, where you must first choose the collaborative organisation in which you want to create your workspace ( in case you are a member of multiple organisations). Once chosen, you a new page will be loaded, where you will have access to all available catalog items. 
<img width="1481" alt="Screenshot_2024-12-11_at_09 11 39" src="https://github.com/user-attachments/assets/75182b41-82dc-4229-a9fe-404debff78ca" />

Use the magnifying glass on the right side of the panel and search for Galaxy. Two catalog items will appear - the Galaxy instance designed for SURF and a Galaxy Pulsar node that can be connected to the instance. Select “Galaxy at SURF”.
<img width="1476" alt="Screenshot_2024-12-11_at_09 15 37" src="https://github.com/user-attachments/assets/db111c30-2c44-4eb1-ba9b-c074886e51f4" />

SURF Research Cloud allows researchers to host their catalog items on different cloud providers. The Galaxy catalog item is currently supported only on the HPC Cloud and for Ubuntu 22.04. On this page, users can select the number of cores and RAM that they want on their machine. More sizes can be added in the future, and on request. Choose wisely and in case you are not certain contact your administrator! 
<img width="1472" alt="Screenshot_2024-12-11_at_09 17 06" src="https://github.com/user-attachments/assets/7847b996-96ee-4a4c-849b-46ad620d1644" />

Select the storage you have created earlier so it is attached to the new workspace. 
<img width="1472" alt="Screenshot 2024-12-10 at 15 52 00" src="https://github.com/user-attachments/assets/7535a0ba-fa96-4d56-98f9-e9dbed923803" />

Lastly, before the workspace is deployed, you need to choose for how long the machine will run. The standard life-time of the VM is 5 days. If you need it for longer, this option can be changed once the machine is running.  Note, that once the machine is expired and deleted it cannot be restored! Plan accordingly and migrate your data in time to prevent data loss!

On the step two, you can select how to name your workspace, add a description (if you want) and specify the hostname. Then, scroll down and submit the workspace creation.
<img width="1474" alt="Screenshot_2024-12-11_at_09 20 26" src="https://github.com/user-attachments/assets/b0cde5ff-b287-4a08-ad82-4ff360d429e2" />

Creating the workspace can take some time. You will see on the main page the status of your workspace. While you are waiting, you can create your Galaxy Pulsar node. 
<img width="762" alt="Screenshot 2024-12-10 at 15 43 45" src="https://github.com/user-attachments/assets/b94d3841-3e5a-4ab4-8e74-22dbf117ebc1" />

Once the workspace is running, press on the down arrow to check any information such as the ID, the owner of the workspace, the collaboration it is part of, when it is created and when it expires and the wallet it is using. Additionally, you can pause the workspace when you are not using it. Pressing on the storage option will display the storage that has been attached to the workspace.

<img width="718" alt="Screenshot 2024-12-11 at 09 58 43" src="https://github.com/user-attachments/assets/20b94a33-8b35-4149-b6f4-49b1b1281aa3" />

To access the Galaxy instance, press on the “Access” button. This will redirect you to a new webpage. The SRAM login will be displayed again, and after authenticating, you will be redirected to the Galaxy at SURF Research Cloud page. 
<img width="1475" alt="Screenshot 2024-12-11 at 10 02 36" src="https://github.com/user-attachments/assets/b591ed3b-f753-4325-889d-77be75f2e3c2" />
Congratulations! You have started a Galaxy instance inside the SURF Research Cloud! 🏄‍♀️🎉

If you have administrator rights, you can download tools that can be used by the members of the collaborative organisation. To obtain administrator rights you need to be part of the src_co_admin group inside the collaborative organisation. In case you are not sure how to download tools as a Galaxy administrator, please refer to [Installing Tools into Galaxy](https://galaxyproject.org/admin/tools/add-tool-from-toolshed-tutorial/) 

Another important step when starting a local Galaxy instance on SRC is connecting it to a Galaxy Pulsar Node. The Pulsar is an useful component that is used to execute your tasks on remote servers/clusters. In this case, the Pulsar is started as a new workspace, allowing users to also run interactive tools.

# Starting a Pulsar workspace 









