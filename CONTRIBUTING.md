# Contribution #

Contribution means helping the project get bigger and better, by any manner.  
If this is what your'e truly looking for, than you've come to the right place!

## Short Brief ##

### What is this file? ###
It is a set of guidence rules for developers who'd like to contribute to this repo.  
API changes, versions go forward but sometimes documentation is not, unfortunately.  
To address those issues and allow developers to contribute good, quality code - This file must exist and always be up to date.

### Dear Contributors ###
First of all, thank you for taking your time even considering contributing to this repo.  
It is extremely improtant to us that you, simple users or continous collaborators, 
contribute to this project in a combined effort to make it greater, stable than ever before.  

## Submitting Issues ##
Requests for new features and bug reports keep the project moving forward.

### Before you submit an issue ###
* Please make sure your'e using the latest version of Arduino CMake. 
  Currently it's the one in the [master](https://github.com/arduino-cmake/arduino-cmake) branch,
  but this will be updated once a version-release standard will be applied.
* Search the [issue list](https://github.com/arduino-cmake/arduino-cmake/issues?utf8=%E2%9C%93&q=is%3Aissue)
  (including closed ones) to make sure it hasn't already been reported.

### Submitting a good issue ### 
Issues can be submitted with a very short description, but that would make the life of the developers addressing it very hard, leading to unresolved issues due to lack of information.  

Here is a set of rules you should apply to **every** issue you submit:

* Give the issue a short, clear title that describes the bug or feature request
* Include your Arduino SDK version
* Include your Operating System (No need to specify exact Linux version (Ubuntu, Fedora, etc.) - Linux is just enough)
* Include steps to reproduce the issue
* If the issue regards a special behavior, maybe related to a specific board - Please tell us all you know about it 
  and put some links to external sources if those exist. Not all of the developers are Arduino experts, and in fact there 
  are so many types of boards and platforms that there being an "Arduino Expert" isn't even real.
* Use markdown formatting as appropriate to make the issue and code more readable.

## Code Contribution

### Code Style
Like pretty much every project, ArduinoCMake uses it'ws own coding style which ensures that everybody can easily read and change files without the hassle of reading 3 different indention styles paired 4 ways of brace spacing.

While we believe, that the coding style you are using benefits you, please try and stick to the current style as close at possible. It is far from perfect (and we ourselves don't like every part that has grown from the project's
past) but it is sufficient to be a common set of rules we can agree on.

For the most basic part, make sure your editor supports `.editorconfig`. 
It will
take care of the greatest hassle like indention, new lines and linebreaks at the end of a file. As for spacing, naming conventions etc. look at the existing code to get an idea of the style. If you use an `IDEA` based IDE (for example `CLion`), chances are that the auto formatting functionality will take care of things due to the project's `codeStyleSettings.xml` residing in the repository.

### Versioning
While in the past the project barely had a proper versioning scheme, we're now trying to incorporate [semantic versioning](http://semver.org/spec/v2.0.0.html). That benefits both developers and users, as there are clear rules about when to bump versions and which versions can be considered compatible.

This versioning scheme also allows easy integration with Git's classic [Workflow Model](http://nvie.com/posts/a-successful-git-branching-model), which is described next.

### Project Workflow

This project follows Git's classic [Workflow Model](http://nvie.com/posts/a-successful-git-branching-model), allowing developers to work on multiple features simultaneously without clashing. This model is a bit different than suggested by **GitHub**, intended mostly for offline Git repositories. However, both models can be easily integrated together to form a single model.

The parts that consist the model are thoroughly described in the following sections.

#### Bug Fixes
Bug fixes can be found in the *stable* release or in a *developed* feature.
The way we treat them is different, described in the next sections.

**Note:** Before claiming to find a bug, make sure you are on the latest commit of that branch.

##### Release Bugs/Critical Bugs

Those are the ones with the highest priority to fix. If you encounter such a bug you should immediately submit a new issue. Before you submit, see [Submitting Issues](#Submitting-Issues). If you'd also like to fix the bug yourself, please state that in the issue.

Fixes to such bugs should be made on a separate branch named `hotfix/B` where `B` is a short description of the bug being solved, separated with a hyphen (`-`) between every word. 
Do note that even though it should describe the bug, it's just a name, thus it shouldn't be too long.
For example the name `hotfix/cmake-not-reloading-when-custom-libraries-are-set` is a bad name, because even though it fits the naming standard and describes the bug, it is way too long for a name.
A better name would be `hotfix/custom-libraries-reloading`.

According to our [Workflow model](#Project-Workflow), once the hotfix is finished you should:

* Merge directly to **master**.
  * Add a tag to the *merge-commit* named after the patched version.
    e.g If the current stable version is v2.1.0, the hotfix should make it v2.1.1 (Bump the patch number). 
* Merge directly to **develop**.
* Use the `--no-ff` flag when merging.

However, **GitHub**'s model support *Pull-Request*s instead of simple *merges*, at least for non-Administrator users (Though should apply for them as well). To comply with the steps listed above, 2 PRs should be made: One to the **master** branch and another to the **develop** branch.
Instead, we accept a single PR to the **master** branch, and will manually merge the rest once the hotfix is finished. Converting that to a list would look like this:

* Pull-Request directly to **master**.
  * Once accepted, the merging administrator will add a tag to the *merge-commit* and bump the patch version (Further described in the previous list).
* An administrator will merge to **develop** or **current release** (Note on that below).
* The `--no-ff` flag will be used when merging.

**Note to Administrators/Collaborators:** If an active **release** branch exists when the hotfix is integrated, meaning there's a planned on-going release, the hotfix should be merged directly to the **release** branch instead of the **develop** branch, unless the hotfix fixes a truly critical bug that affects development as well.

##### Development Bugs

Those are easier to find and fix since they exist only in **feature** branches, planned for future releases and considered in development. If you encounter such a bug you can submit a new issue, however it is not necessary if you'd like to fix the bug yourself.

Fixes to such bugs should be made on a separate branch, preferably in a forked version, named after the bug. Once finished, you should PR it to the appropriate **feature** branch. If the **feature** branch has already been merged to **develop**, the merging administrator will take care of merging the branch to develop again.

#### Feature Additions
To ensure your contribution makes it into the mainline codebase, always check the **develop** branch for the next targeted release. Make sure your contribution is on par with that branch and PR features back into **develop**. This strategy should be the right one for most users. If you want to make further additions to a feature currently under development, you can also PR into the corresponding **feature** branch.

##### Feature Branch Naming

**Feature** branch names should be short and descriptive, each word separated by a single hyphen (`-`).
e.g A branch named `feature/blacklisting-libraries-to-avoid-automatic-inclusion-when-reloading-cmake` is a bad branch name because it's too long, even though it's very descriptive. A better name would be `feature/library-blacklist` because it's short and generally descriptive. Any further description would be written in commit messages or the final PR to the **develop** branch.

#### Releases

When a handful of features is complete, the developed product is ready for release.
According to our [Workflow model](#Project-Workflow), every release should start with a branch named after the about-to-be-released version. e.g `release/2.0.0`.

There are some strict rules we apply to our releases:

* At any given moment there should be a <u>single</u> release or no release at all. We're not working Agile on this project, thus there's no need for multiple simultaneous releases.
* Once existing, any hotfix should be merged to the **release** branch instead of the **develop** branch (See [Release Bugs](#Release-Bugs/Critical-Bugs)).
* Any last-minute bug-fixes should be made directly on the **release** branch. They will be merged later to the **develop** branch once the release is completed.
* New features developed after the release has been started are intended for the <u>next</u> release.
* Before completing the release the `CHANGELOG.md` file should be updated accordingly.

Once the release is complete it is merged to the **master** branch and to the **develop** branch.
A tag with the final release version is also added to the *merge-commit* on **master**.

### Pull Requests

As this is GitHub, we support merging by Pull-Requesting. It helps us document code better, as well as discussing and reviewing a change before it gets into the mainline codebase.
So please - Make a Pull Request for every change you'd like to make, yes, even if your'e an administrator or a collaborator.

Also note that we do have a strict rule about the branch your'e PRing from - Once it gets merged, it will be deleted. This is done to avoid unnecessary cluttering of the project. If you need to keep the branch for some reason, please state it in **bold** in the PR's description, so that the merging user will notice it.

### Breaking Changes
Breaking changes require the release of a new major version according to *semver* rules. 
So if you are going to make changes to the **public** interface that are not backwards-compatible, make sure it is **absolutely** necessary.

### Changelog
From v2.0.0 on, we are going to take note of changes in a proper `CHANGELOG.md`.
For any contribution, please add a corresponding changelog entry.  
Bump the patch version for bug fixes and the minor version for feature additions.  
Don't **ever** bump the major version on your behaf - It should be done only by the owners of the project.
