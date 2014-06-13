require "formula"

class Fswatch < Formula
  homepage "https://github.com/alandipert/fswatch"
  url "https://github.com/alandipert/fswatch/archive/1.3.6.tar.gz"
  sha1 "e3dc16f2b181452f864a7cb4718d1aa0f8a0ee2f"

  bottle do
    cellar :any
    sha1 "f72d8496ac893e2e7314f5a1b405ec4bc8a0d4da" => :mavericks
    sha1 "7c2ee61eb7346ff3fc0873ed3dc568aaf60cb8dc" => :mountain_lion
    sha1 "9fb2150adee74b9717b4c3fb5d21e122fb440541" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  needs :cxx11

  def install
    ENV.cxx11
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end
end
