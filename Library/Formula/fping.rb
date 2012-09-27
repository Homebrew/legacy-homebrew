require 'formula'

class Fping < Formula
  homepage 'http://fping.org/'
  url 'http://fping.org/dist/fping-3.2.tar.gz'
  sha1 'a1f8e00ecc6d5e7089748e2587713b07c7335fc1'

  head 'https://github.com/schweikert/fping.git'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end

  def caveats; <<-EOS.undent
    fping can only be run by root by default so either use sudo to run fping or
        setuid root #{sbin}/fping

    EOS
  end

end
