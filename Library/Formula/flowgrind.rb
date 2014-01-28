require 'formula'

class Flowgrind < Formula
  homepage 'https://launchpad.net/flowgrind'
  url 'https://launchpad.net/flowgrind/trunk/flowgrind-0.6.1/+download/flowgrind-0.6.1.tar.bz2'
  sha1 'aaa4714dbbe2bb8d5eb249a0d526f4bc7023db2c'

  depends_on 'gsl'
  depends_on 'xmlrpc-c'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
