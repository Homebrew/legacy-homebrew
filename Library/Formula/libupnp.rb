require 'formula'

class Libupnp < Formula
  homepage 'http://pupnp.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.19/libupnp-1.6.19.tar.bz2'
  sha1 'ee9e16ff42808521b62b7fc664fc9cba479ede88'

  bottle do
    cellar :any
    sha1 "1034504a16dd58821bf1ca90c302301c3a9884e9" => :mavericks
    sha1 "4af1bc09d1c4325ba3b726ddcd6206a9cf6cd3cc" => :mountain_lion
    sha1 "f5068736c9ca5fc46fb8aeb27abc2735c1beda33" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
