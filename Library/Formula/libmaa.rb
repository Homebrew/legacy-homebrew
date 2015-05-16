require "formula"

class Libmaa < Formula
  homepage "http://www.dict.org/"
  url "https://downloads.sourceforge.net/project/dict/libmaa/libmaa-1.3.2/libmaa-1.3.2.tar.gz"
  sha1 "4540374c9e66e3f456a8102e0ae75828b7892c6d"

  bottle do
    cellar :any
    revision 1
    sha1 "2e87bbf21b8e9775341599459524078ac0f505b1" => :yosemite
    sha1 "b2750220edec8b59538b80a3b0a32020fd662eaa" => :mavericks
    sha1 "fc5057ee1f5b99573028908d15285aea445a74b9" => :mountain_lion
  end

  depends_on "libtool" => :build

  def install
    ENV["LIBTOOL"] = "glibtool"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

