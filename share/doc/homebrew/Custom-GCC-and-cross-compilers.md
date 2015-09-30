# Custom GCC and cross compilers
Homebrew depends on having an up-to-date version of Xcode because it comes with specific versions of build tools e.g. `clang`.

Installing a custom version of GCC or `autotools` into the `$PATH` has the potential to break lots of compiles so we prefer the Apple or Homebrew provided compilers.

Cross-compilers based on GCC will typically be "keg-only" and therefore not linked into the path by default.

Rather than merging in brews for either of these cases at this time, we're listing them on this page. If you come up with a formula for a new version of GCC or cross-compiler suite, please link it in here.

* Homebrew provides a `gcc` formula for use with Xcode 4.2+ or when needing C++11 support on earlier versions.
* [Homebrew-versions](https://github.com/homebrew/homebrew-versions) provides an up to date GCC duplicates e.g. `brew install homebrew/versions/gcc48`
* [MSP430 development](https://github.com/Homebrew/homebrew/issues/issue/2336)
* [OS161 development](https://github.com/maxpow4h/homebrew-os161) Your university probably uses a different version, replacing the URLs with your university's URLs will probably work.
* [ARM-EABI](https://github.com/paxswill/homebrew-paxswill) provides an arm-none-eabi toolchain formula.
* [RISC-V](https://github.com/riscv/homebrew-riscv) provides the RISC-V toolchain including binutils and gcc.
