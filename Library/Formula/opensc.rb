require 'formula'

class Opensc < Formula
  url 'http://www.opensc-project.org/files/opensc/opensc-0.12.2.tar.gz'
  homepage 'http://www.opensc-project.org/opensc'
  md5 '5116adea5f2f9f22fb9896965789144b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
