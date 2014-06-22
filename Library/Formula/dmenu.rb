require 'formula'

class Dmenu < Formula
  homepage 'http://tools.suckless.org/dmenu/'
  url 'http://dl.suckless.org/tools/dmenu-4.5.tar.gz'
  sha1 '70c1a13b950b7b0cb1bc35e30c6e861a78359953'
  head 'http://hg.suckless.org/dmenu/'

  option 'with-command-key', 'Use Mac OS X comamnd key as modifier key'

  depends_on :x11

  def install
    if build.with? 'command-key'
      inreplace 'dmenu.c', 'Mod1Mask', 'Mod2Mask'
    end

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/dmenu", "-v"
  end
end
