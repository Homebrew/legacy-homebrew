def blacklisted? name
  case name.downcase
  when 'screen', /^rubygems?$/ then <<-EOS.undent
    Apple distributes #{name} with OS X, you can find it in /usr/bin.
    EOS
  when 'libarchive', 'libpcap' then <<-EOS.undent
    Apple distributes #{name} with OS X, you can find it in /usr/lib.
    EOS
  when 'libiconv' then <<-EOS.undent
    Apple distributes #{name} with OS X, you can find it in /usr/lib.
    Some build scripts fail to detect it correctly, please check existing
    formulae for solutions.
    EOS
  when 'libxml', 'libxlst' then <<-EOS.undent
    Apple distributes #{name} with OS X, you can find it in /usr/lib.
    However not all build scripts look for these hard enough, so you may need
    to call ENV.libxml2 in your formula's install function.
    EOS
  when 'wxpython' then <<-EOS.undent
    The Python bindings (import wx) for wxWidgets are installed by:
        brew install wxwidgets
    EOS
  when 'tex', 'tex-live', 'texlive', 'latex' then <<-EOS.undent
    Installing TeX from source is weird and gross, requires a lot of patches,
    and only builds 32-bit (and thus can't use Homebrew deps on Snow Leopard.)

    We recommend using a MacTeX distribution: http://www.tug.org/mactex/
    EOS
  when 'pip' then <<-EOS.undent
    pip is installed by `brew install python`
    EOS
  when 'macruby' then <<-EOS.undent
    MacRuby works better when you install their package:
      http://www.macruby.org/
    EOS
  when /(lib)?lzma/
    "lzma is now part of the xz formula."
  when 'xcode' then <<-EOS.undent
    Xcode can be installed via the App Store (on Lion or newer), or from:
      http://connect.apple.com/
    EOS
  when 'gtest', 'googletest', 'google-test' then <<-EOS.undent
    Installing gtest system-wide is not recommended; it should be vendored
    in your projects that use it.
    EOS
  when 'gmock', 'googlemock', 'google-mock' then <<-EOS.undent
    Installing gmock system-wide is not recommended; it should be vendored
    in your projects that use it.
    EOS
  when 'gcc' then <<-EOS.undent
    GCC is now maintained in homebrew-versions, with major version
    number in formula name as suffix. Please tap using:

        brew tap homebrew/versions

    and then install GCC based on its version, e.g., 'brew install gcc47'.
    EOS
  when 'sshpass' then <<-EOS.undent
    We won't add sshpass because it makes it too easy for novice SSH users to
    ruin SSH's security.
    EOS
  end
end
