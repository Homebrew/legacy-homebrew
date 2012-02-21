require 'formula'

class Xdotool < Formula
  homepage 'http://www.semicomplete.com/projects/xdotool/'
  url 'http://semicomplete.googlecode.com/files/xdotool-2.20110530.1.tar.gz'
  md5 '62d0c2158bbaf882a1cf580421437b2f'

  depends_on 'pkg-config' => :build

  def install
    system "make", "PREFIX=#{prefix}", "INSTALLMAN=#{man}", "install"
  end

  def caveats; <<-EOS.undent
    You will probably want to enable XTEST in your X11 server now by running:
      defaults write org.x.X11 enable_test_extensions -boolean true

    For the source of this useful hint:
      http://stackoverflow.com/questions/1264210/does-mac-x11-have-the-xtest-extension
    EOS
  end
end
