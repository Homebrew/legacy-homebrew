require 'formula'

class Fping < Formula
  homepage 'http://fping.org/'
  url 'http://fping.org/dist/fping-3.4.tar.gz'
  sha1 '52e13afb2e6a27ec8ec69e6e10f103c4a7a1afe7'

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
