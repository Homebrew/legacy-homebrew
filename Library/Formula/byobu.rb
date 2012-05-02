require 'formula'

class Byobu < Formula
  url 'http://launchpad.net/byobu/trunk/5.17/+download/byobu_5.17.orig.tar.gz'
  homepage 'http://launchpad.net/byobu'
  md5 '50551374a67dbf77349b0b453044ed6c'

  depends_on 'coreutils'
  
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
