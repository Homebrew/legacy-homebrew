class Libmaa < Formula
  desc "Low-level data structures including hash tables, sets, lists"
  homepage "http://www.dict.org/"
  url "https://downloads.sourceforge.net/project/dict/libmaa/libmaa-1.3.2/libmaa-1.3.2.tar.gz"
  sha256 "59a5a01e3a9036bd32160ec535d25b72e579824e391fea7079e9c40b0623b1c5"

  bottle do
    cellar :any
    revision 1
    sha256 "2187eee3e1d3b9dd54fabbf1be63c388458af7986f0f470f31a6111d47212227" => :yosemite
    sha256 "c0919efec1d1e0661a8228914a90c0f482b720622f31033841631819c6c4d1df" => :mavericks
    sha256 "60bd1424f0ef468d95248fa6c3bf4845f2b5b649829623160c1b85b82be3ad57" => :mountain_lion
  end

  depends_on "libtool" => :build

  def install
    ENV["LIBTOOL"] = "glibtool"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

