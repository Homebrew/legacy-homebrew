require 'formula'

class Vimpager < Formula
  homepage 'https://github.com/rkitover/vimpager'
  url 'https://github.com/rkitover/vimpager/tarball/1.5.6'
  sha256 '8f80d5abd5119a110e1431c3f9c5acf26934b605f44eb036e84fbf0845248697'
  head 'https://github.com/rkitover/vimpager', :using => :git

  def install
    inreplace "vimpager.1", "~/bin/", ""

    bin.install 'vimpager'
    man1.install 'vimpager.1'
  end

  def caveats; <<-EOS.undent
    To use vimpager as your default pager, add `export PAGER=vimpager` to your
    shell configuration.
    EOS
  end
end
