require "formula"

class Libmaa < Formula
  homepage "http://www.dict.org/"
  url "https://downloads.sourceforge.net/project/dict/libmaa/libmaa-1.3.2/libmaa-1.3.2.tar.gz"
  sha1 "4540374c9e66e3f456a8102e0ae75828b7892c6d"

  bottle do
    cellar :any
    sha1 "f6202ebc9283ce8cf0b9718561220a3ed8f96926" => :mavericks
    sha1 "9c45a8050f4b200d492840fb5532cae843895240" => :mountain_lion
    sha1 "fe07fcbbf99da2816532a525bbf585d2185edda6" => :lion
  end

  depends_on "libtool" => :build

  def install
    ENV["LIBTOOL"] = "glibtool"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

