require "formula"

class Monotone < Formula
  homepage "http://monotone.ca/"
  url "http://www.monotone.ca/downloads/1.1/monotone-1.1.tar.bz2"
  sha1 "2b97559b252decaee3a374b81bf714cf33441ba3"

  bottle do
    sha1 "70755c4f5193a0e2848f8af7430a44884b3622e2" => :mavericks
    sha1 "5121ea09374b924b087f50b72e7754f27d7c4c2a" => :mountain_lion
    sha1 "94730a4384bda8b5f13967dd92bc2ba80060b7c5" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libidn"
  depends_on "lua"
  depends_on "pcre"
  depends_on "botan"
  # Monotone only needs headers, not any built libraries
  depends_on "boost" => :build

  fails_with :llvm do
    build 2334
    cause "linker fails"
  end

  def install
    botan = Formula["botan"]

    ENV["botan_CFLAGS"] = "-I#{botan.opt_include}/botan-1.10"
    ENV["botan_LIBS"] = "-L#{botan.opt_lib} -lbotan-1.10"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
