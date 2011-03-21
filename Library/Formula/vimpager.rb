require 'formula'

class Vimpager < Formula
  homepage 'https://github.com/rkitover/vimpager'
  url 'https://github.com/rkitover/vimpager/tarball/1.4.4'
  sha1 '6273a3fbe25a13e12943d8ac46527a2004636d75'
  head 'git://github.com/rkitover/vimpager', :using => :git

  def install
    bin.install 'vimpager'
  end

  def caveats; <<-EOS.undent
    To use vimpager as your default pager, add `export PAGER=vimpager` to your
    shell configuration.
    EOS
  end
end
