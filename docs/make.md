## Development Routines (develop.mk)
| Target | Description |
|---|------------------|
| hlp           | Generate Documentation for makefile system              |

## Release Routines (release.mk)
| Target | Description |
|---|------------------|
| stat          | Show generic statistics on the codebase                 |
| release-clean | Clean the project. Do this before making the Archive    |
| release-arch  | Make an iOS Archive, when done you can find it in the ./build folder |
| release-ipa   | Export ipa from the archive. IPA file will be in the same folder as archive (./build) |
| release-distr | Distribute to the Firebase. Do not forget to have updated Release-Notes.txt |
| release-full  | Run the full release pipeline                           |

## Test Routines (test.mk)
| Target | Description |
|---|------------------|
| tdests        | Show possible destinations                              |
| tests         | Run All Unit tests, generate CodeCoverage report        |
| tests-count   | Calculate the Count of Test Functions                   |
| tcc           | Calculate the Code Coverage                             |

## Versioning routines (version.mk)
| Target | Description |
|---|------------------|
| ver-get       | Get the current version of the application (stored in the $PROJECT/Confog.xcconfig |
| ver-inc-build | Increase the BUILD number, no push to repository        |
| ver-inc-patch | Increase the PATCH version, no push to repository       |
| ver-inc-minor | Increase the MINOR version, no push to repository       |

