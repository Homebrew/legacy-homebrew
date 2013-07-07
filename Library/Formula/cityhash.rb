require 'formula'

class Cityhash < Formula
  homepage 'https://code.google.com/p/cityhash/'
  url 'https://cityhash.googlecode.com/files/cityhash-1.1.0.tar.gz'
  sha1 '83ce3fd30a6454e1e2b1a531731a76ba74650889'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end
end
