This branch contains brews that duplicate built-in OS X functionality.

As an example, OS X comes with zlib 1.2.3, which has been the most recent
version since July 18, 2005. Should there be a security update, no doubt
Apple would include it in an OS X point release.

As it is the philosophy of Homebrew not to duplicate system functionality,
using a self-compiled zlib in lieu of the system library is strongly
discouraged. Because of this, there is currently no compelling reason to
include a zlib formula.


The formulae in this branch of are "academic interest", since they 
have not been determined to have any advantage over the corresponding
OS X system libraries.

Should a new version come out that OS X does not adopt, or better compile-
time options come to light, they may be promoted into the master branch.
