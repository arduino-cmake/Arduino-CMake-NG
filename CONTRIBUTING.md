# Contribution #

## Short Brief ##

### What is this file? ###
It is a set of guidance rules for developers who'd like to contribute to this repo.  
Versions go forward, new features are added, the API can change, but sometimes  - Documentation doesn't keep the pace, unfortunately.  
To address those issues and allow developers to contribute good, quality code - This file must exist and always be up to date.

### Dear Contributors ###
First of all, thank you for taking your time even considering contributing to this repo.  
It is extremely important to us that you, ordinary users or continuous collaborators, contribute to this project in a combined effort to make it greater, stable than ever before.  

## Submitting Issues ##
New features and bug reports keep the project moving forward and getting better.  
This is partly your duty, the user, to request those features and report the bugs.

### Before you submit an issue ###
* Please make sure your'e using the latest version of **Arduino CMake**.  
  Generally it's the [latest release](https://github.com/arduino-cmake/Arduino-CMake-NG/releases), unless said otherwise by any of the maintainers.
* Go over the existing issue list (including closed ones) to make sure your issue hasn't already been reported or fixed.

### Submitting a good issue ### 
Issues can be submitted with a very short description, but that would make the life of the developers addressing it very hard, leading to unresolved issues due to lack of information.  

Here is a set of rules you should apply to **every** issue you submit:

* Give the issue a short, clear title that describes the bug or feature request
* Describe the steps to reproduce the issue
* If the issue regards a special behavior, maybe related to a specific board - Please tell us all you know about it and put some links to external sources if those exist
* Use Markdown formatting as appropriate to make the issue and code more readable

#### Issue Signature

At last, you should sign your issue with a special signature, following the next format:

```
OS: [Windows|OSx/MacOS|Linux]
Distribution (Linux Only): [Fedora|Debian|Ubuntu|CentOS] etc.
OS Version: [Version]
Platform: [Arduino|ESP32|Pinoccio] etc.
Platform SDK Version: [Version]
```

**Disclaimers:**

* *etc.* means that there multiple other options.
* SDK versions usually have the form of [major].[minor].[patch], such as 1.8.5.
* OS Distribution should be mentioned only for Linux-based OSs

## Code Contribution

### Code Style
Like most projects, **Arduino-CMake** uses its own coding style which ensures that everybody can easily read and change files without the hassle of reading 3 different indentation styles paired 4 ways of brace spacing.

While we believe that the coding style you are using benefits you, please try and stick to the project's accepted style as close as possible.  
For starters, make sure your editor supports `.editorconfig`.  
It will take care of the some of the greatest hassles like indentation, new lines and such.  
As for spacing, naming conventions, etc.  - Please look at existing code to get an idea of the style.  
If you use an Jetbrains `IDEA` based IDE (for example `CLion`), chances are that the auto formatting functionality will take care of things due to the project's `codeStyleSettings.xml` residing in the repository.

### Versioning
This project follows the [semantic versioning](http://semver.org/spec/v2.0.0.html).   
It also allows easy integration with our [Workflow Model](#Project Workflow), which is described next.

### Project Workflow

Up to version *0.6*, included, this project followed Git's [Classic Workflow Model](http://nvie.com/posts/a-successful-git-branching-model), allowing developers to work on multiple features simultaneously without clashing. This model is a bit different than suggested by **GitHub**, intended mostly for offline Git repositories.  
For this reason the project has adapted the model to GitHub's model from version *0.6.x* and above.

The elements of the adapted model are thoroughly described in the following sections.

#### Bug Fixes
Bug fixes can be found in the *stable release* or in a *developed feature*.  
The way we treat them is different, described in the next sections.

**Note:** Before claiming to find a bug, make sure you are on the latest commit of that branch.

##### Release Bugs/Critical Bugs

Those are the ones with the highest priority to fix. If you encounter such a bug you should immediately submit a new issue. Before you submit, please see [Submitting Issues](#Submitting-Issues).  
If you'd like to fix the bug yourself, please **state that** in the issue.

Fixes to such bugs should be made on a separate branch named `hotfix/B` where `B` is a short description of the bug being solved, separated with a hyphen (`-`) between every word.  
Do note that even though it should describe the bug, it's just a name, thus it shouldn't be too long.  
For example the name `hotfix/cmake-not-reloading-when-platform-libraries-are-used` is a bad name, because even though it fits the naming standard and describes the bug, it is way too long for a name.
A better name would be `hotfix/platform-libraries-reloading`.

According to our [Workflow model](#Project-Workflow), once the hotfix is finished one should:

1. Add a tag to the *merge-commit* named after the patched version.
   e.g If the current stable version is v2.1.0, the hotfix should make it v2.1.1 (Bump the patch number). 
2. Pull-Request directly to **master**

The [Classic Workflow Model](http://nvie.com/posts/a-successful-git-branching-model) lists that a hotfix should be *merged* to both **master** and **develop**, however, GitHub doesn't play nicely with this exact model and basically allows only one of the branches to exist in such a workflow that respects *Pull-Requests* (Instead of *merges*) on one side, and the Workflow model on another.

**Note to Maintainers/Collaborators:** 
If an active **release** branch exists when the hotfix is integrated, meaning there's an on-going release, the hotfix should be also be *merged* to the **release** branch, optionally from the **master** branch if a *merge* from the hotfix branch isn't possible.

##### Development Bugs

These exist in **feature** branches or the **master** branch - Code that's planned for future releases and considered in development.  
However, these still need to be reported by submitting relevant issues. You should also specify if your'e attempting to fix them.

Fixes to such bugs should be made on a separate branch, preferably in a forked version, named after the bug. Once finished, you should PR it to the appropriate **feature** branch or directly to the **master** branch - depending on where you found them.  
If the **feature** branch has already been merged to **master**, you should simply PR directly to **master**.

#### New Features
To ensure your contribution makes it into the mainline codebase, always check the **master** branch for the next targeted release.  
Make sure your contribution is on par with that branch, then PR directly into **master**. 
This strategy should be the right one for most users.  
If you want to make further additions to a feature currently under development, you can also PR into the corresponding **feature** branch.

##### Feature Branch Naming

**Feature** branch names should be short and descriptive, each word separated by a single hyphen (`-`).
e.g A branch named `feature/blacklisting-libraries-to-avoid-automatic-inclusion-when-reloading-cmake` is a bad branch name because it's too long, even though it's very descriptive.  
A better name would be `feature/library-blacklist` because it's short and generally descriptive.  

Any further description would be written in commit messages or the final PR to the **master** branch.

#### Releases

When a handful of features is complete, the developed product is ready for release.
According to our [Workflow model](#Project-Workflow), every release should start with a branch named after the *about-to-be-released* version. e.g `release/2.0.0`.

There are some strict rules we apply to our releases:

* At any given moment there should be a <u>single release</u> **or** <u>no release at all</u>. 
  We're not working Agile on this project, thus there's no need for multiple simultaneous releases.
* Once existing, any hotfix should be merged to the **release** branch as well as to the **master** branch (See [Release Bugs](#Release-Bugs/Critical-Bugs)).
* Any last-minute bug-fixes should be made directly on the **release** branch. 
  They will be merged later to the **master** branch once the release is completed.
* New features developed after the release has been started are intended for the <u>**next** release</u> - They should be merged only to the **master** branch!
* Before completing the release: 
  * Documentation should be up-to-date (Currently maintained in GitHub Wiki)
  * **Changelog** file should be updated accordingly
  * **Authors** file should be updated accordingly

Once the release is complete it is merged to the **master** branch.  
A tag with the final release version is also added to the *merge-commit* on **master**.

### Pull Requests

At GitHub we support merging by Pull-Requesting.  
It helps us document code better, as well as discussing and reviewing a change before it gets into the mainline codebase.

Please make a Pull Request for every change you'd like to make, yes, <u>even if your'e an maintainer or a collaborator</u>.

Also note that we do have a strict rule about the branch your'e PRing from - Once it gets merged, it will be probably get deleted. This is done to avoid unnecessary cluttering of the project.  
If you need to keep the branch for some reason, please state it in **bold** in the PR's description, so that the merging user will notice it.

### Breaking Changes
Breaking changes require the release of a new major version according to [semantic versioning](#Versioning) rules.  
If your'e making changes to the **public** interface (API) that are not backwards-compatible, make sure it is **absolutely** necessary.

### Changelog
All project changes, new features and bug fixes are documented in `CHANGELOG.md`.  
<u>**Maintainers**</u> - For any contribution, please add a corresponding changelog entry.  
Bump the patch version for bug fixes and the minor version for feature additions.  
Don't **ever** bump the major version on your behalf - It should be done only by the maintainers of the project.
