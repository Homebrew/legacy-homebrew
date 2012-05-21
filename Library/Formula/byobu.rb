require 'formula'

class Byobu < Formula
  homepage 'http://launchpad.net/byobu'
  url 'http://launchpad.net/byobu/trunk/5.18/+download/byobu_5.18.orig.tar.gz'
  md5 '5940cef1ae3d750b5712793a90901d67'

  depends_on 'coreutils'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Add the following to your shell configuration file:
      export BYOBU_PREFIX=$(brew --prefix)
    EOS
  end
end
