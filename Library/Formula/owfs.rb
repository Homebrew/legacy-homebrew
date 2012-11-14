require 'formula'

class Owfs < Formula
  homepage 'http://owfs.org/'
  url 'http://downloads.sourceforge.net/project/owfs/owfs/2.8p20/owfs-2.8p20.tar.gz'
  version '2.8p20'
  sha1 'ccfe8b794fd224221538d2f85c6d9774254c58f5'

  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-swig",
                          "--disable-owtcl",
                          "--disable-zero",
                          "--disable-owpython",
                          "--disable-owperl",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
