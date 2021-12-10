### Let's Start!

1. First go to [Github.com](https://github.com) and sign up for GitHub or sign in if you already have an account.
2. Click on the (![New_Repository](https://user-images.githubusercontent.com/42538229/137142260-0070134d-99f3-4ab9-a5df-3a3d799abeca.png)
 in the repository menu in the top left.
3.	Create the repository by using the following settings:
   * Repository name = Github_Tutorial_Beginner
   * Description = Github tutorial for working with github for the first time.
   * Set to Private (so it is only viewable for you, this is changed later)
   * Select “Add a README file”
   * Press the “Create repository” button

---

Your almost empty repository is made. The only information inside is the README.md file. This file contains the main information about your study/review/game/tool/or whatever you want in your github. Now it looks something like this:<br>
![Preview_Empty-Repository](https://user-images.githubusercontent.com/42538229/137144572-0ea43459-897c-4beb-a271-67d9ee80582f.png)

---

4. Click on the :pencil2: icon to add the README file.
5. To line 3 add the following: Whoohoo, I'm working in Github for the first time! :grin: <br>
At the bottom in the Commit changes section add the discription: Added my first line! <br>
Use the Commit changes to change the file.

>These descriptions can help to remember what you've done at a later stage.<br>
---

We can see that our senteance isn't separated by an enter.<br>
![image](https://user-images.githubusercontent.com/42538229/137146991-808769f3-808f-479d-b21e-59aae2fbdf39.png)
So we're going to change the file again!

---

6. To change this we can add an extra enter, so line 3 becomes an empty line or we can place a <'br> (without ') at the end of the senteance. <br>
*For now we will use the extra enter on line 3*

---

We're going to check out some of the Markdown syntax. <br>
Markdown is a language that can be converted into for example HTML, but is a lot easier to write and read. <br>
The markdown syntax is easy to use and you can find a lot of cheatsheets of it online like this:
[Cheat Sheet](https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf)


**Text Styles**

\**Bold **<br>
**Bold** <br>
control b or command b

\_Italic_ <br>
_Italic _<br>
control i or command i

\`Code\` <br>
`Code` <br>
control e or command e

\[Link Avans](https://www.avans.nl/) <br>
[Link Avans](https://www.avans.nl/)<br>
control k or command k

---

**Headers:**<br>
\# Header1 <br>
# Header1
\## Header2 <br>
## Header 2
\### Header3 <br>
### Header3

---

**Tables:**<br>
First Header | Second Header<br>
\-------------|--------------<br>
Content cell 1 | Content cell 2<br>
Content column 1 | Content column 2<br>

First Header | Second Header
------------ | -------------
Content cell 1 | Content cell 2
Content column 1 | Content column 2

---

**(Python) Code Blocks**<br>

\`\`\`Python<br>
num = 1+1<br>
print(num)<br>
\`\`\`<br>

```python
num = 1+1
print(num)
```

---

7. Now you are going to make a table which shows 4 different syntaxes inside.<br>
With a header3 saying Syntax table<br>
Something like this:<br>

### Syntax Table

Syntax | Preview
---------- | ----------
Bold  | **Bold**
Italic | _Italic_
Strikethrough | ~~Crossed out~~
Inline code | `inline code`

8. In the bottom part where the Commit changes are select:<br>
Create a new branch for this commit and start a pull request<br>
Change name to [username]-syntax-table and press "Propose changes"

9. Under write add a discription and click "Create pull request"

---

If you now go back to your main repository folder (by clicking on the Github_Tutorial name in the top left.<br>
You'll see nothing is changed in the README.md file.<br>
![image](https://user-images.githubusercontent.com/42538229/137311987-43219157-3e70-4bfb-9427-69a6e296b106.png)

But you can see you've added a new branch:<br>
![image](https://user-images.githubusercontent.com/42538229/137312097-4aedf009-8498-4c26-b294-e90642ebd527.png)

---

10. Now change the branch to your recently made branch.
![image](https://user-images.githubusercontent.com/42538229/137312217-8e468622-83b1-4fe0-90fa-6893995646bd.png)

---

Here you can see that your recently added table is added to the README file:<br>
![image](https://user-images.githubusercontent.com/42538229/137312339-365a45c3-a617-4304-814f-87874161868d.png)

To merge these we go to the tab Pull Requests ![image](https://user-images.githubusercontent.com/42538229/137312419-1677328a-704c-448c-b7fe-9936756ec032.png)

---

11. Now click on the Update README.md
![image](https://user-images.githubusercontent.com/42538229/137312503-585a82f5-9929-48fc-871f-7953db04c90e.png)


Here you'll find 4 Tabs.<br>
- Conversations --> Here you can discuss with other colaborators about this pull request (PR) and give comments.
- Commits --> Check what was changed in the file and by whom. (if you click the blue numbers you can see what was changed in each update)
- Checks --> This is an advanced option, where an costum script can be used to check PR's.
- Files changed --> Here you can easily see what is changed in the files. (Red and - is removed / Green and + is added)

A pull request can also be initiated by other members in a shared repository. <br>
If you agree with the changes in this PR, you can merge the pull request. <br>
_For more information about the merging of pull request check:_ [Information Pull Requests](https://docs.github.com/en/github/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/about-pull-request-merges)

---

12. In the Conversation Tab click the Merge and pull request button and press the green button again.

---

Now you can see that both branches are now the same.<br>
With these branches you can work on your repository without changing the main branch.<br>
Multiple branches can exist at the same time.<br>
By clicking the branch icon you can see an overview of all branches and are able to remove them as well.

### Let's take a 10 minute break.


# Welcome to Part 2 of the tutorial!!

Now we start by adding 2 headers in the README file, so it's clear what was in the first and second tutorial.
1. Add 2 ## headers with Part1 and Part2.

Next, we're adding a new folder with it's own README file, which will include a galaxy workflow (file + picture)<br>
For this you can use your own made galaxy workflow + screenshot or you can use the one from the example

2. First we are going to make the the new folder and README.md file<br>
    - Click on the "Add file" and select "Create new file"
    - After the Github_Tutorial/ add: `Workflows/README.md`
    - (This will add the folder Workflows and the file README at once)
    - In this file:<br>
            - Start with a header<br>
            - Write an explanation what is in the folder<br>
            - Add the file link under the explanation<br>
            - Add the picture underneath and make sure it is shown in the README file<br>
            - Now commit<br>
            - Now add the file to the folder

Then you'll get something like this:<br>
![image](https://user-images.githubusercontent.com/42538229/137340643-be4fb3f6-8fcd-472a-ade5-418e6132a85e.png)

3. Now create a link to the workflow folder in the main README file, using: ./Workflows as link.<br>
![image](https://user-images.githubusercontent.com/42538229/137859398-9fbe45ae-9f5e-4749-844d-396ca6ea8aec.png)

Now you'll have to do the same thing, without the picture, to get something like this:<br>
![image](https://user-images.githubusercontent.com/42538229/137875081-a74a49c0-e161-49d0-89f9-41568cec5050.png)

4. Now add the new folder + README + python script (make sure you can make the script public) and add it all to a new branch.<br>
In the README in the python folder, use the python code syntax to add your python code to the README file.<br>
Only when finished with the whole folder, use the pull request to merge them.

5. Add the link to the python_scripts folder to the main README file. (use: ./python_scripts)

By using ./python_scripts you are softcoding the link. By doing this someone else can also copy your repository, with working links connecting to their copied repository. If you hardcode it your links will connect you to the original repository.

---

Finally we're going to check the history/commits to our repository.

6. By clicking the ![image](https://user-images.githubusercontent.com/42538229/137876400-908ccb4c-6b0f-461e-b939-24702cdccc05.png) or ![image](https://user-images.githubusercontent.com/42538229/137876517-c841cd6e-4f34-4529-bce8-4a88f8a672fc.png) icon you can see each modification of your repository/folder/file.<br>
This can be very helpful to see what other people contributed to the repository or to seek errors in code or tools.

Now you should know enough to create your own repository and do the general modification in github.

