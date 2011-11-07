require 'formula'

class Xdotool < Formula
  url 'http://semicomplete.googlecode.com/files/xdotool-2.20110530.1.tar.gz'
  homepage 'http://www.semicomplete.com/projects/xdotool/'
  md5 '62d0c2158bbaf882a1cf580421437b2f'

  depends_on 'pkg-config' => :build

  def install
    system "make", "PREFIX=#{prefix}", "INSTALLMAN=#{man}", "install"

    ohai "You will probably want to enable XTEST in your X11 server now by running:\n"
    ohai "defaults write org.x.X11 enable_test_extensions -boolean true\n"
    ohai "(see http://stackoverflow.com/questions/1264210/does-mac-x11-have-the-xtest-extension"
    ohai "for the source of this useful hint - thx to Nicholas Riley for providing that)"
  end

  def test
    system "xdotool version"
  end
end
