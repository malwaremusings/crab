# crab: Challenge-Response Authentication with a Bourne Shell script.

This is me reminiscing and recreating some shell scripts that I wrote to protect my university UNIX account from replay attacks after learning that credentials can be captured off the network in clear text.

## Features

- Prevents an unauthorised user from logging in to a UNIX shell account by entering the same user credentials and responses entered by an authorised user.
- User files and security algorithm script cannot be read using FTP with the user's credentials.
- Cannot be interrupted/bypassed via ctrl-c.
