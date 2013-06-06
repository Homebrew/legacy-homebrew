require 'formula'

class Xdotool < Formula
  homepage 'http://www.semicomplete.com/projects/xdotool/'
  url 'http://semicomplete.googlecode.com/files/xdotool-2.20110530.1.tar.gz'
  sha1 'bf8372b2e76e8ee3884763cee6e8b3f66bf29aa6'

  depends_on 'pkg-config' => :build

  depends_on :x11

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
