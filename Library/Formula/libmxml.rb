require "formula"

class Libmxml < Formula
  homepage "http://www.minixml.org/"
  url "http://www.msweet.org/files/project3/mxml-2.8.tar.gz"
  sha1 "09d88f1720f69b64b76910dfe2a5c5fa24a8b361"

  bottle do
    cellar :any
    sha1 "2e60a4f242cd9649db0f22e44cca871217555430" => :mavericks
    sha1 "d74e8af4f586cc1e64507d9d33c365c95729b77a" => :mountain_lion
    sha1 "e39d4413c184522bfcaf3e43a22ef5395d790a82" => :lion
  end

  depends_on :xcode => :build # for docsetutil

  def install
    system "./configure", "--disable-debug",
                          "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
