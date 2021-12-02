# Welcome to part 3 of the tutorial

<br>
Everybody likes some quality of life to make work a little better. <br>For working with Github alot, is the internet webpage not optimal.<br> Luckly are there various tools to help us, one of these tools is Visual Code Studio (VCS).
<br><br>
VCS is a source-code editor made by Microsoft and can run on Windos, Linux and macOS. It features debugging, syntax highlighting, snippets, codere fractoring and is even embedded in git. <br>Thereby are there alot of extensions available online to customise VCS to your needs.<br> In this tutorial the installation to creating and using git will be explained.<br> It is also possible to run various commands in the terminal or even python scripts.<br><br>

# Contents

- Installation
- Extensions
- Overview of Visual Code studio
- Accesing a github
- Making branches and adjust codes
- Pull requests
- Reviewing
- Final note & Whats next

<br><br>

## Installation

Like the most programs, can it be easily installed by using internet.<br> click [here](https://code.visualstudio.com/) for a link to download VCS. <br>
Complete the installation by using default settings.

![image](images/Download.png)

<br><br><br>




## Extensions

Before we start the whole tutorial lets hook you up with some upgrades, lets install a few extensions.<br>
Extensions are little software packages who can install new features of make some quality of life changes.<br>

This can be an Interprentor for a piece of code (R, C++, python, Java), a proofreader for spelling mistakes or an extension who makes markdown easier for you. <br>
 It is worth it, to look online which are avaialble and suit your needs.<br>

Search for the following extensions by clicking on the extension button in the left bar. ![image](images/Extension.png)
- Github Pull Requests and Issues.
- Github Repositories.
- Python.

![image](images/install_extension.png)
<br>
<br>

## Overview of VCS

VCS contains alot of awesome features but can be quite overwhelming in the start.<br> Luckly we already installed some extensions for quality of life.<br>
The following gives a small overview of all functions of the tabs in VCS.<br>


- Explorer. In this  tab are all files of the current github repository.<br> This is currently still empty, but not for long! <br>
- Search, a search function for in your github repository.<br>
- Source controll, if you edited and saved a file from a github, is here your change to make an pull request or to commit it directly.<br>
- Run and debug, is for running files, for example "hello_world.py".<br>
- Extensions, a place where you can go shopping for new plugins.<br>
- Remote exporer, an overview of previous githubs where you have been.<br>
- Github, here is the real magic.<br> Every github repository you own or are admin for will notification be sended to this tab.<br> when a person makes a pull request, issue, review etc.<br> you will get an automated message here.<br> With this you can easily keep an eye on all your (team)projects.<br>

![image](images/layout.png)

On the top bar of VCS are various tabs which can be quite usefull.<br>
It also possible to openup a terminal and run various codes. <br>

On the bottom of the window is the workspace and branch you are working in. <br>
![image](images/onderste_balk.png)


But enough talking, lets get into some action!<br><br><br>



## Getting access to a github repository

Remember the repository you made, lets open it up.<br>
click on the green box in the left under box. ![image](images/github_knopje.png)<br>

This will open a small terminal above and click on "open remote repository".<br>
![image](images/open_repository_box.png)
 
 In this window you fill in the URL of the github repository you created earlier.<br>
![image](images/open_repository_2.png)


Every time you have added a github repository, you dont have to search the url again.<br>
When you click on the the remote explorer tab, you will find a overview off all repository you have worked in.<br>
you also see if you need to update a repository locally in VCS.<br>
In this is it also possible to look up pull requests and access pulled repositories.<br>
When you have done this, is it possible to view and edit all files in the explorer tab.<br>

![image](images/all_repositories.png) <br><br>


## Making branches and adjust codes

Working directly on someone else main branch should not be possible unless you are the owner or the admin of the repository.<br> There by is it also incredible rude to just change someone elses work. <br> It is also good practise to work to work in branches.<br><br>
You can see branches as a copy of the main where a new feature or version will be implemented and tested before merging it back to main. <br> With this can you safely test codes or debug it while other people work on a different feature, in a branch from main.<br>
![image](images/branches.png)


Lets Create our first Branch on someone else github repository!<br>
- open the repository of this github tutorial or the github repository of someone else in the previous parts of the tutorial. <br>
````
https://github.com/Avans-ATGM/Github_Tutorial
````
- Create a new branch to work in and give it a usefull name.<br>
A new branch can be opend by clicking on this button below ![image](images/branch_button.png) <br> and click on ``` + Create new branch ``` <br>
since we are testing, lets call it 
````
test_[your_username]
````

So now we have a copy from the mainbranch. in this we can code and give adjustment. <br> After we edited or created some new files we can merge it back into main by creating a pull request
<br>
In the Examples directory is the file "Nucleotide_Counter.py" which can be edited or look for other interesting files. <br>

Here we see a for loop to count all the nucleotides. Since we are pretty good Python coders we can improve it. ![image](images/nucleotide_counter.py.png)

Lets make it a dictionary loop to reduce the number of lines.<br> It should look like something like this.

![image](images/Nucleotide_counter_edited.png)

Safe all your work locally by clicking on file and then safe, or close the window and a message will pop up. <br><br>

## Opening a pull request
When you have made a fork or branch with a new feature and it is finished, you can merge it to the main branch. <br> In this process all changes, deletions and additions will be added to the files you edited in the main branch for everyone to use.<br>
We have edited the python code to be more efficient and lesser lines. 
Lets make a pull request to merge it back to the main branch.

- click on the Source controll tab.
- click on commit to safe all changes to your current branch.
- click on create pull request. <br> 

The following window should pop up.<br>
In this window is it possible to define to what branch your branch should be merged with.<br>
Remember to give the pull request a meaningfull name (fixing typo's in github_tutorial.md) in the description can you give a more detailed explaination about what and why you changed codes.


![image](images/pull_request.png)


## Reviewing a pull request

 
So you have created your first pull request. but that doesnt mean that all changes are directly onto the main branch. Commonly do other Github maintainers of the repository review your new branch. <br> Even in VCS can you get an message that someone created a pull request for an Github repository you own or are admin of.<br> This can be incredible usefull when working together on a group project.

You can find these in the Github tab and gives the following overview.<br>
![image](images/open_pull_request.png)

Once The pull request is openend you can see which files are added, removed or changed.<br>
For example this is the python code we adjusted.

![image](images/differences.png)


Inside the code is it also possible for reviewers to comment on a line of your code.<br> In this certain questions or unclearity can be asked.<br> The comment can be made to hover with your cursor on a line number, a plus symbol should pop up.<br> Clicking on the plus symbol gives a discussion thread where you can add comments or start reviewing.<br> If this occours in your repository which you own or manage, you will also get a email notification that this has occourd by someone else.<br> In Visual Code Studio can you also see the comments and even the response of reviewers

![image](images/commenting.png) <br><br>

![image](images/reviewing.png) <br><br>

In this phase of reviewing is it commonly that codes will still be adjusted or questions be asked before it is approved for reviewing.<br>
When you click on description you see the total overview of the pull request and accept the request. <br>It is also possible to ask for certain reviewers

![image](images/reviewing2.png) <br><br>


## Final note & Whats next

So incase you are not convinced yet to work with github, here are a few reasons why:
- Always have a backup for your code.
- You can always revert changes incase it doesnt work out.
- It is more easier to see what changes when working with collebrators.
- multiple cool advanced options, for example to test the code when you created a commit.
- overview of issues and a task managers.

### future reading

In case you really do like Visual code Studio, you can also run python or other coding languages in it.
click [here](https://code.visualstudio.com/docs/languages/python) for more information. 



