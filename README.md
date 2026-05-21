# PathPlanning_PathTools_GetUserInputPath

<!--
The following template is based on:
Best-README-Template
Search for this, and you will find!
>
<!-- PROJECT LOGO -->
<br />
<p align="center">
  <!-- <a href="https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a> -->

  <h2 align="center"> PathPlanning_PathTools_GetUserInputPath
  </h2>

  <pre align="center">
    <img src=".\Images\fcn_GetUserInputPath_getUserInputPath_Reber.png" alt="main getuserinput picture" width="832" height="505">
    <!--figcaption>Fig.1 - The typical progression of map generation.</figcaption -->
    <font size="-2">Photo by <a href="https://unsplash.com/@alicekat?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Alice Donovan Rouse</a> on <a href="https://unsplash.com/photos/sand-pathway-surrounding-grass-pZ61ZA8QgcY?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
    </font>
</pre>

  <p align="center">
    The purpose of this code is to collect user points as they click on a figure.
    <br />
    <!-- a href="https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation/tree/main/Documents">View Demo</a>
    <a href="https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation/issues">Report Bug</a>
    <a href="https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation/issues">Request Feature</a -->
  </p>
</p>

***

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About the Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li>
      <a href="#directories">Repo Structure</a>
      <ul>
        <li><a href="#directories">Top-Level Directories</a></li>
        <li><a href="#dependencies">Dependencies</a></li>
      </ul>
    </li>
    <li>
      <a href="#functions">Functions</a>
      <ul>
        <li><a href="#basic-support-functions">Basic Support Functions</a></li>
        <li><a href="#core-functions">Core Functions</a></li>
        <li><a href="#fcn_getuserinputpath_getuserinputpath">fcn_GetUserInputPath_getUserInputPath</a></li>
      </ul>
    </li>
    <li>
      <a href="#usage">Usage</a>
      <ul>
        <li><a href="#general-usage">General Usage</a></li>
        <li><a href="#examples">Examples</a></li>
      </ul>
    </li>
    <li>
      <a href="#geographicaxes-usage">GeographicAxes Usage</a>
    </li>
    <li>
      <a href="#interactive-controls">Interactive Controls</a>
    </li>
    <li>
      <a href="#license">License</a>
    </li>
    <li>
      <a href="#major-release-versions">Major Release Versions</a>
    </li>
    <li>
      <a href="#contact">Contact</a>
    </li>
  </ol>
</details>
***

<!-- ABOUT THE PROJECT -->
## About The Project

<!--[![Product Name Screen Shot][product-screenshot]](https://example.com)-->

This repository contains MATLAB tools for interactively collecting user-defined geometric data from figures. The core function, `fcn_GetUserInputPath_getUserInputPath`, lets users click directly on a plot or map to create paths, point sets, filled patches, or axis-aligned bounding boxes.

The tool supports standard XY axes as well as MATLAB `GeographicAxes`, making it suitable for both regular plots and map-based workflows. It can be used to manually trace road boundaries, lane edges, obstacles, map regions, or other spatial features and return the selected data as structured MATLAB coordinate arrays.

Supported drawing modes include `path`, `points`, `patch`, and `aabb`. The function also supports right-click `[NaN NaN]` separators for splitting paths or creating independent patch areas, as well as point insertion, deletion, dragging, and view panning during interactive input.

<a href="#pathplanning_pathtools_getuserinputpath">Back to top</a>

***

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Installation

1. Make sure to run MATLAB 2020b or higher. Why? The "digitspattern" command used in the DebugTools utilities was released late 2020 and this is used heavily in the Debug routines. If debugging is shut off, then earlier MATLAB versions will likely work, and this has been tested back to 2018 releases.

2. Clone the repo

   ```sh
   git clone https://github.com/ivsg-psu/pathplanning_pathtools_getuserinputpath
   ```

3. Run the main code in the root of the folder (script_demo_Laps.m), this will download the required utilities for this code, unzip the zip files into a Utilities folder (.\Utilities), and update the MATLAB path to include the Utility locations. This install process will only occur the first time. Note: to force the install to occur again, delete the Utilities directory and clear all global variables in MATLAB (type: "clear global *").
4. Confirm it works! Run script_demo_Laps. If the code works, the script should run without errors. This script produces numerous example images such as those in this README file.

<a href="#pathplanning_pathtools_getuserinputpath">Back to top</a>

***

<!-- STRUCTURE OF THE REPO -->
### Directories

The following are the top level directories within the repository:
<ul>
 <li>/Documents folder: Descriptions of the functionality and usage of the various MATLAB functions and scripts in the repository.</li>
 <li>/Functions folder: The majority of the code for the point and patch association functionalities are implemented in this directory. All functions as well as test scripts are provided.</li>
 <li>/Utilities folder: Dependencies that are utilized but not implemented in this repository are placed in the Utilities directory. These can be single files but are most often folders containing other cloned repositories.</li>
</ul>

<a href="#pathplanning_pathtools_getuserinputpath">Back to top</a>

***

### Dependencies

* [Errata_Tutorials_DebugTools](https://github.com/ivsg-psu/Errata_Tutorials_DebugTools) - The DebugTools repo is used for the initial automated folder setup, and for input checking and general debugging calls within subfunctions. The repo can be found at: <https://github.com/ivsg-psu/Errata_Tutorials_DebugTools>

* [PathPlanning_PathTools_PathClassLibrary](https://github.com/ivsg-psu/PathPlanning_PathTools_PathClassLibrary) - the PathClassLibrary contains tools used to find intersections of the data with particular line segments, which is used to find start/end/excursion locations in the functions. The repo can be found at: <https://github.com/ivsg-psu/PathPlanning_PathTools_PathClassLibrary>

    Each should be installed in a folder called "Utilities" under the root folder, namely ./Utilities/DebugTools/ , ./Utilities/PathClassLibrary/ . If you wish to put these codes in different directories, the main call stack in script_demo_(reponame) can be easily modified with strings specifying the different location, but the user will have to make these edits directly.

    For ease of getting started, the zip files of the directories used - without the .git repo information, to keep them small - are included in this repo.

<a href="#pathplanning_pathtools_getuserinputpath">Back to top</a>

***

<!-- FUNCTION DEFINITIONS -->
## Functions

### Basic Support Functions

***

### Core Functions

#### fcn_GetUserInputPath_getUserInputPath

`fcn_GetUserInputPath_getUserInputPath` is the core function of this repository. It provides an interactive MATLAB interface for collecting user-defined geometry directly from a figure. The user clicks on a standard XY plot or on a MATLAB `GeographicAxes` map, and the function returns the selected coordinates as a MATLAB array.

The function supports four drawing modes:

- `path`: collects connected line segments from user-selected points.
- `points`: collects discrete points without connecting them.
- `patch`: creates filled polygonal areas from user-selected points.
- `aabb`: creates one axis-aligned bounding box from two opposite corners.

Right-clicking inserts a `[NaN NaN]` row, which separates independent path or patch sections. This allows the user to define multiple disconnected paths or multiple independent patch areas within a single function call.

The function also supports basic interactive editing:

- `-`: removes the most recent point.
- `d`: deletes the closest selected point.
- `i`: inserts a new point into the nearest existing segment.
- Click-drag: moves an existing point or pans the current view.
- `Return`: finishes the user input and returns the selected data.

For `aabb` mode, the function is intended to define one bounding box per function call. The user selects two opposite corners, and the function returns a closed five-point rectangle. If additional points are selected, the second corner is updated rather than creating multiple boxes.

The function can also start from an existing `startingXY` array, allowing previous user input to be loaded, displayed, edited, and returned again.

<pre align="center">
  <img src=".\Images\fcn_GetUserInputPath_getUserInputPath.png" alt="fcn_GetUserInputPath_getUserInputPath picture" width="400" height="300">
  <figcaption>Fig - The function fcn_GetUserInputPath_getUserInputPath collects interactive user-defined geometry from standard XY axes and GeographicAxes.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

<a href="#pathplanning_pathtools_getuserinputpath">Back to top</a>

***

<!-- USAGE EXAMPLES -->
## Usage
<!-- Use this space to show useful examples of how a project can be used.
Additional screenshots, code examples and demos work well in this space. You may
also link to more resources. -->
The main workflow is based on calling `fcn_GetUserInputPath_getUserInputPath` from an existing MATLAB figure. The figure can use either standard XY axes or MATLAB `GeographicAxes`.

The function waits for the user to interactively select points and returns the selected coordinates when the `Return` key is pressed.


### General Usage

```
pathXY = fcn_GetUserInputPath_getUserInputPath(startingXY, figNum, inputType);
````
Where:
- startingXY is an optional Nx2 array of existing points to load and edit.
- figNum is the MATLAB figure number where the user input should be collected.
- inputType defines the drawing mode.
Supported values for `inputType`:

     * 'path'
     * 'points'
     * 'patch'
     * 'aabb'

***

### Examples

1. Path mode

Use path mode to collect connected line segments.

Left-click adds points to the path. Right-click inserts a [NaN NaN] separator, allowing the user to start a new disconnected path section.

<pre align="center">
  <img src=".\Images\path_mode.png" alt="fcn_GetUserInputPath_getUserInputPath picture" width="428" height="270"
  4">
  <figcaption>Fig - Example of path mode, where user-selected points are connected as continuous line segments. </figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

2. Points mode

Use points mode to collect discrete points without connecting them.

<pre align="center">
  <img src=".\Images\points_mode.png" alt="fcn_GetUserInputPath_getUserInputPath picture" width="441" height="305"
  4">
  <figcaption>Fig - Example of points mode, where user-selected locations are displayed as individual discrete points without connecting lines.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

3. Patch mode

Use patch mode to define filled polygonal areas.

<pre align="center">
  <img src=".\Images\patch_mode.png" alt="fcn_GetUserInputPath_getUserInputPath picture" width="440" height="301"
  4">
  <figcaption>Fig - Example of points mode, where user-selected locations are displayed as individual discrete points without connecting lines.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

When at least three valid points are available, the selected points define a filled patch. Right-click inserts a [NaN NaN] separator, allowing multiple independent patch areas to be defined in the same call.

4. AABB mode

Use aabb mode to define one axis-aligned bounding box from two opposite corners.

<pre align="center">
  <img src=".\Images\aabb_mode.png" alt="fcn_GetUserInputPath_getUserInputPath picture" width="440" height="301"
  4">
  <figcaption>Fig - Example of points mode, where user-selected locations are displayed as individual discrete points without connecting lines.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

The returned result is a closed four-point rectangle. This mode is intended to define one AABB per function call. If additional points are selected, the second corner is updated rather than creating additional boxes.

<a href="#pathplanning_pathtools_getuserinputpath">Back to top</a>

<!-- GeographicAxes -->
## GeographicAxes Usage

The same function can be used on MATLAB GeographicAxes.
```
figNum = 5;
figure(figNum); clf;

fcn_plotRoad_plotLL([], [], figNum);
set(gca, 'MapCenter', [40.793695059681355 -77.864213807810174], 'ZoomLevel', 20);

pathXY = fcn_GetUserInputPath_getUserInputPath([], figNum, 'path');
```

This allows users to collect paths, points, patches, or AABBs directly from map-based views.

<pre align="center">
  <img src=".\Images\GeographicAxes.png" alt="fcn_GetUserInputPath_getUserInputPath picture" width="471" height="313"
  4">
  <figcaption>Fig - Example of Geographic Axes map. </figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>


<!-- INTERACTIVE CONTROLS -->
## Interactive Controls
During interaction, the following controls are available:

| Action                      | Behavior                                          |
| --------------------------- | ------------------------------------------------- |
| Left-click                  | Adds a point                                      |
| Right-click                 | Inserts a `[NaN NaN]` separator                   |
| Click-drag on a point       | Moves the selected point                          |
| Click-drag away from points | Pans the current view                             |
| `-`                         | Removes the most recent point                     |
| `d`                         | Deletes the closest point                         |
| `i`                         | Inserts a point into the nearest existing segment |
| `Return`                    | Finishes input and returns the selected data      |


<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.

<a href="#pathplanning_pathtools_getuserinputpath">Back to top</a>

***

## Major release versions

This code is still in development (alpha testing)

<a href="#pathplanning_pathtools_getuserinputpath">Back to top</a>

***

<!-- CONTACT -->
## Contact

Sean Brennan - [sbrennan@psu.edu](sbrennan@psu.edu)

Project Link: [hhttps://github.com/ivsg-psu/pathplanning_pathtools_getuserinputpath](https://github.com/ivsg-psu/pathplanning_pathtools_getuserinputpath)

<a href="#pathplanning_pathtools_getuserinputpath">Back to top</a>

***

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
