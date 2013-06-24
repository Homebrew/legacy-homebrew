require 'formula'

class Fping < Formula
  homepage 'http://fping.org/'
  url 'http://fping.org/dist/fping-3.5.tar.gz'
  sha1 'b2552aa5b9450c660e37761c3e5efe8ac28c83d2'

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
