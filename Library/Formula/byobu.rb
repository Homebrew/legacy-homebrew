require 'formula'

class Byobu < Formula
  url 'http://launchpad.net/byobu/trunk/5.12/+download/byobu_5.12.orig.tar.gz'
  homepage 'http://launchpad.net/byobu'
  md5 '15c3d0fd2923fba0a6d77fc52d59b81a'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    After installing, add the following path to your .bashrc or .zshrc file:
      export BYOBU_PREFIX=`brew --prefix`
    EOS
  end
end
