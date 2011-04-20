require 'formula'

class Vimpager < Formula
  homepage 'https://github.com/rkitover/vimpager'
  url 'https://github.com/rkitover/vimpager/tarball/1.4.7'
  sha256 '4bd8bb65ad4ad360264e89cf13dd798089e177716eea2db3a4dcdb558bbdd46c'
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
