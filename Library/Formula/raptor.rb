require 'formula'

class Raptor < Formula
  homepage 'http://librdf.org/raptor/'
  url 'http://download.librdf.org/source/raptor2-2.0.15.tar.gz'
  sha1 '504231f87024df9aceb90eb957196b557b4b8e38'

  bottle do
    cellar :any
    revision 1
    sha1 "f7cecc5f216e22af901503d4d2a0dc1b067a17dc" => :yosemite
    sha1 "91e0f02cf40d73b1a8d2086dd9e99b5b68865ba7" => :mavericks
    sha1 "90e06f872ef68f2ddfd1db49be3caad6f9f3cf6a" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
