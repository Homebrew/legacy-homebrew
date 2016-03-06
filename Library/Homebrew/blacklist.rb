def blacklisted?(name)
  case name.downcase
  when "gem", /^rubygems?$/ then <<-EOS.undent
    Homebrew provides gem via: `brew install ruby`.
    EOS
  when "tex", "tex-live", "texlive", "latex" then <<-EOS.undent
    Installing TeX from source is weird and gross, requires a lot of patches,
    and only builds 32-bit (and thus can't use Homebrew deps on Snow Leopard.)

    We recommend using a MacTeX distribution: https://www.tug.org/mactex/

    You can install it using Cask:

    brew cask install mactex
    EOS
  when "pip" then <<-EOS.undent
    Homebrew provides pip via: `brew install python`. However you will then
    have two Pythons installed on your Mac, so alternatively you can install
    pip via the instructions at:

      https://pip.readthedocs.org/en/stable/installing/#install-pip
    EOS
  when "pil" then <<-EOS.undent
    Instead of PIL, consider `pip install pillow` or `brew install Homebrew/python/pillow`.
    EOS
  when "macruby" then <<-EOS.undent
    MacRuby works better when you install their package:
      http://www.macruby.org/
    EOS
  when /(lib)?lzma/
    "lzma is now part of the xz formula."
  when "xcode"
    if MacOS.version >= :lion
      <<-EOS.undent
      Xcode can be installed from the App Store.
      EOS
    else
      <<-EOS.undent
      Xcode can be installed from https://developer.apple.com/xcode/downloads/
      EOS
    end
  when "gtest", "googletest", "google-test" then <<-EOS.undent
    Installing gtest system-wide is not recommended; it should be vendored
    in your projects that use it.
    EOS
  when "gmock", "googlemock", "google-mock" then <<-EOS.undent
    Installing gmock system-wide is not recommended; it should be vendored
    in your projects that use it.
    EOS
  when "sshpass" then <<-EOS.undent
    We won't add sshpass because it makes it too easy for novice SSH users to
    ruin SSH's security.
    EOS
  when "gsutil" then <<-EOS.undent
    Install gsutil with `pip install gsutil`
    EOS
  when "clojure" then <<-EOS.undent
    Clojure isn't really a program but a library managed as part of a
    project and Leiningen is the user interface to that library.

    To install Clojure you should install Leiningen:
      brew install leiningen
    and then follow the tutorial:
      https://github.com/technomancy/leiningen/blob/stable/doc/TUTORIAL.md
    EOS
  when "osmium" then <<-EOS.undent
    The creator of Osmium requests that it not be packaged and that people
    use the GitHub master branch instead.
    EOS
  when "gfortran" then <<-EOS.undent
    GNU Fortran is now provided as part of GCC, and can be installed with:
      brew install gcc
    EOS
  when "play" then <<-EOS.undent
    Play 2.3 replaces the play command with activator:
      brew install typesafe-activator

    You can read more about this change at:
      https://www.playframework.com/documentation/2.3.x/Migration23
      https://www.playframework.com/documentation/2.3.x/Highlights23
    EOS
  when "haskell-platform" then <<-EOS.undent
    We no longer package haskell-platform. Consider installing ghc
    and cabal-install instead:
      brew install ghc cabal-install

    A binary installer is available:
      https://www.haskell.org/platform/mac.html
    EOS
  when "mysqldump-secure" then <<-EOS.undent
    The creator of mysqldump-secure tried to game our popularity metrics.
    EOS
  end
end
