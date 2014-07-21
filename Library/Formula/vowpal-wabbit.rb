require "formula"

class VowpalWabbit < Formula
  homepage "https://github.com/JohnLangford/vowpal_wabbit"
  head "https://github.com/JohnLangford/vowpal_wabbit.git"
  url "https://github.com/JohnLangford/vowpal_wabbit/archive/7.7.tar.gz"
  sha1 "d248bc848ad3919ad0c5002045a83aa29d83e6fd"

  bottle do
  end

  depends_on "boost" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV["AC_PATH"] = "#{HOMEBREW_PREFIX}/share"
    system "./autogen.sh", "--prefix=#{prefix}",
                           "--with-boost=#{Formula['boost'].opt_prefix}"
    system "make"
    system "make", "install"
  end
end
