require 'formula'

class Raptor < Formula
  homepage 'http://librdf.org/raptor/'
  url 'http://download.librdf.org/source/raptor2-2.0.14.tar.gz'
  sha1 'f0dc155ee616aac0e5397dd659519c9d0a262f21'

  bottle do
    cellar :any
    sha1 "b22317b19b16764738fdd3bffeb80b86379d293a" => :mavericks
    sha1 "b2e832498b362a0a2da1935c9901445496bdf33e" => :mountain_lion
    sha1 "64dffefd3d044632e10a9a3c768f670d62ec1c8b" => :lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
