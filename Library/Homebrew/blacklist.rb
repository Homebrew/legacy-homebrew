def blacklisted? name
  case name.downcase
  when 'screen', /^rubygems?$/ then <<-EOS.undent
    Apple distributes #{name} with OS X, you can find it in /usr/bin.
    EOS
  when 'libpcap' then <<-EOS.undent
    Apple distributes #{name} with OS X, you can find it in /usr/lib.
    EOS
  when 'libiconv' then <<-EOS.undent
    Apple distributes #{name} with OS X, you can find it in /usr/lib.
    Some build scripts fail to detect it correctly, please check existing
    formulae for solutions.
    EOS
  when 'tex', 'tex-live', 'texlive', 'latex' then <<-EOS.undent
    Installing TeX from source is weird and gross, requires a lot of patches,
    and only builds 32-bit (and thus can't use Homebrew deps on Snow Leopard.)

    We recommend using a MacTeX distribution: http://www.tug.org/mactex/
    EOS
  when 'pip' then <<-EOS.undent
    Homebrew provides pip via: `brew install python`. However you will then
    have two Pythons installed on your Mac, so alternatively you can:
        sudo easy_install pip
    EOS
  when 'pil' then <<-EOS.undent
    Instead of PIL, consider `pip install pillow` or `brew install Homebrew/python/pillow`.
    EOS
  when 'macruby' then <<-EOS.undent
    MacRuby works better when you install their package:
      http://www.macruby.org/
    EOS
  when /(lib)?lzma/
    "lzma is now part of the xz formula."
  when 'xcode'
    if MacOS.version >= :lion
      <<-EOS.undent
      Xcode can be installed from the App Store.
      EOS
    else
      <<-EOS.undent
      Xcode can be installed from https://developer.apple.com/downloads/
      EOS
    end
  when 'gtest', 'googletest', 'google-test' then <<-EOS.undent
    Installing gtest system-wide is not recommended; it should be vendored
    in your projects that use it.
    EOS
  when 'gmock', 'googlemock', 'google-mock' then <<-EOS.undent
    Installing gmock system-wide is not recommended; it should be vendored
    in your projects that use it.
    EOS
  when 'sshpass' then <<-EOS.undent
    We won't add sshpass because it makes it too easy for novice SSH users to
    ruin SSH's security.
    EOS
  when 'gsutil' then <<-EOS.undent
    Install gsutil with `pip install gsutil`
    EOS
  when 'clojure' then <<-EOS.undent
    Clojure isn't really a program but a library managed as part of a
    project and Leiningen is the user interface to that library.

    To install Clojure you should install Leiningen:
      brew install leiningen
    and then follow the tutorial:
      https://github.com/technomancy/leiningen/blob/stable/doc/TUTORIAL.md
    EOS
  when 'rubinius' then <<-EOS.undent
    Rubinius requires an existing Ruby 2.0 to bootstrap.
    Doing this through Homebrew is error-prone. Instead, consider using
    `ruby-build` to build and install specific versions of Ruby:
        brew install ruby-build
    EOS
  when 'osmium' then <<-EOS.undent
    The creator of Osmium requests that it not be packaged and that people
    use the GitHub master branch instead.
    EOS
  when 'gfortran' then <<-EOS.undent
    GNU Fortran is now provided as part of GCC, and can be installed with:
      brew install gcc
    EOS
  when 'play' then <<-EOS.undent
    Play 2.3 replaces the play command with activator:
      brew install typesafe-activator

    You can read more about this change at:
      http://www.playframework.com/documentation/2.3.x/Migration23
      http://www.playframework.com/documentation/2.3.x/Highlights23
    EOS
  end
end
