require 'formula'

class Fping < Formula
  homepage 'http://fping.org/'
  url 'http://fping.org/dist/fping-3.6.tar.gz'
  sha1 '85aac6084d5ccef2b5a4c4eb892f891576c0c0fd'

  head 'https://github.com/schweikert/fping.git'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    fping can only be run by root by default so either use sudo to run fping or
        setuid root #{sbin}/fping
    EOS
  end
end
