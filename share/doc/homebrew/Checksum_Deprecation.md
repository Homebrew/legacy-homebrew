# Checksum Deprecation

During early 2015 Homebrew started the process of deprecating _SHA1_ for package
integrity verification. Since then every formulae under the Homebrew organisation
has been moved onto _SHA256_ verification; this includes both source packages
and our precompiled packages (bottles).

We also stopped supporting _MD5_ entirely. It was removed from core formulae in 2012 but until April 2015 if you tried to install a formula still using an
_MD5_ checksum Homebrew wouldn't actively stop you.

On _SHA1_ we added a `brew audit` check that flags _SHA1_ checksums as deprecated
and requests that you use _SHA256_.

We saw positive ecosystem engagement on moving from _MD5_ & _SHA1_ to the recommended _SHA256_ and thanks to that we're in a strong position to move forwards.

## Moving forwards on SHA1.

From March 20th 2016 we've stepped up the visibility of that notification & you'll start
seeing deprecation warnings when installing _SHA1_-validated formula.
If you see these please consider reporting it to where the formula originated.

We're targeting **the end of September 2016** for _SHA1_ support removal,
19 months after we started warning people to move away from it for verification.
This will be enforced in the same way _MD5_ is today, by blocking the installation of that individual formula until the checksum is migrated.

This means prior to that date custom taps, local custom formulae, etc
need to be migrated to use _SHA256_.
