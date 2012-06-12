require 'formula'

class Fping < Formula
  homepage 'http://fping.org/'
  url 'https://github.com/schweikert/fping/tarball/3.1'
  sha1 '1584e662ef3ba08e239e626df73ec74bc34548ee'

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
