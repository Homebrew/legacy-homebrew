require 'formula'

class Nsd < Formula
  homepage 'http://www.nlnetlabs.nl/projects/nsd/'
  url 'http://www.nlnetlabs.nl/downloads/nsd/nsd-3.2.13.tar.gz'
  sha1 '2cb44f75e9686fd73c7ee9765857a36a8fe5bca9'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
