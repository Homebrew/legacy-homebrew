class Libmaa < Formula
  desc "Low-level data structures including hash tables, sets, lists"
  homepage "http://www.dict.org/"
  url "https://downloads.sourceforge.net/project/dict/libmaa/libmaa-1.3.2/libmaa-1.3.2.tar.gz"
  sha256 "59a5a01e3a9036bd32160ec535d25b72e579824e391fea7079e9c40b0623b1c5"

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

