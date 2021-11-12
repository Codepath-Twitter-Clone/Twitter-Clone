# Twitter

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
The team is building an MVP version of Twitter with strictly Swift UI using the MVVM architecture. We will be building this completely from scratch, starting with the User Interface skeleton, and working our way up to integrating our API with Firebase and data models. We will be building all the core components of a social network. This includes following users, uploading/liking tweets, direct messaging, creating a user profile, and registering users.

### App Evaluation
- Social
- UI/UX for mobile iOS experience
- A service for friends, family, and coworkers to stay connected through the exchange of quick, frequent messages
- 353 million active users
- Twitter audience most receptive, valuable for its influence, and brand conscious
- Very mature technology

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Following users
* Viewing tweets
* Uploading/liking/commenting tweets
* Creating/editing a user profile
* Log-in/sign-up users

**Optional Nice-to-have Stories**

* Direct messaging
* Search users
* Recommendation system

### 2. Screen Archetypes

* Login
   * Login
* Signup
   * Signup
* Main
   * Viewing tweets
   * Following users
   * liking tweets
* Profile
   * Creating/editing a user profile
* Post
   * Uploading tweets
* Tweet
   * Viewing tweets details
   * Viewing tweets comments
   * Commenting tweets
   * Following users
   * liking tweets

### 3. Navigation

**Tab Navigation** (Tab to Screen)
* No tab navigation needed.

**Flow Navigation** (Screen to Screen)

* Login
   * Main
* Signup
   * Login
* Main
   * Post
   * Profile
   * Tweet
* Profile
   * Main
* Post
   * Tweet
* Tweet
   * Main

## Wireframes
<img src="https://github.com/Codepath-Twitter-Clone/Twitter-Clone/blob/main/Twitter%20UI%20Screens/0001.jpg" width=600>
<img src="https://github.com/Codepath-Twitter-Clone/Twitter-Clone/blob/main/Twitter%20UI%20Screens/0002.jpg" width=600>
<img src="https://github.com/Codepath-Twitter-Clone/Twitter-Clone/blob/main/Twitter%20UI%20Screens/0005.jpg" width=600>
<img src="https://github.com/Codepath-Twitter-Clone/Twitter-Clone/blob/main/Twitter%20UI%20Screens/0006.jpg" width=600>
<img src="https://github.com/Codepath-Twitter-Clone/Twitter-Clone/blob/main/Twitter%20UI%20Screens/0007.jpg" width=600>
<img src="https://github.com/Codepath-Twitter-Clone/Twitter-Clone/blob/main/Twitter%20UI%20Screens/0008.jpg" width=600>
<img src="https://github.com/Codepath-Twitter-Clone/Twitter-Clone/blob/main/Twitter%20UI%20Screens/0009.jpg" width=600>
<img src="https://github.com/Codepath-Twitter-Clone/Twitter-Clone/blob/main/Twitter%20UI%20Screens/0010.jpg" width=600>
<img src="https://github.com/Codepath-Twitter-Clone/Twitter-Clone/blob/main/Twitter%20UI%20Screens/0013.jpg" width=600>
<img src="https://github.com/Codepath-Twitter-Clone/Twitter-Clone/blob/main/Twitter%20UI%20Screens/0014.jpg" width=600>
<img src="https://github.com/Codepath-Twitter-Clone/Twitter-Clone/blob/main/Twitter%20UI%20Screens/0022.jpg" width=600>

## Schema 
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
