## Generate Documentation for makefile system (develop.mk)
| Target | Description |
|---|------------------|
| hlp           | Generate Documentation for makefile system              |

## Make Releases (release.mk)
| Target | Description |
|---|------------------|
| stat          | Show generic statistics on the codebase                 |
| r-clean       | Clean the project. Do this before making the Archive    |
| r-arch        | Make an iOS Archive, when done you can find it in the ./build folder |
| r-ipa         | Export ipa from the archive. IPA file will be in the same folder as archive (./build) |
| r-distr       | Distribute to the Firebase. Do not forget to have updated Release-Notes.txt |

## MARKETING_VERSION = CFBundleShortVersionString (e.g., 1.2.3) (version.mk)
| Target | Description |
|---|------------------|
| v-get         | Get the current version of the application (stored in the $PROJECT/Confog.xcconfig |
| v-inc-build   | Increase the BUILD number, no push to repository        |
| v-inc-patch   | Increase the PATCH version, no push to repository       |
| v-inc-minor   | Increase the MINOR version, no push to repository       |

