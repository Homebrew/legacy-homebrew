class Scheme48 < Formula
  desc "Scheme byte-code interpreter"
  homepage "http://www.s48.org/"
  url "http://s48.org/1.9.2/scheme48-1.9.2.tgz"
  sha256 "9c4921a90e95daee067cd2e9cc0ffe09e118f4da01c0c0198e577c4f47759df4"

  bottle do
    sha256 "2e85f609127d8741396d644722dbce29bf25b5fc06b76b96edda580f5ec3c260" => :mavericks
    sha256 "e539425e96aec1a83017061ebcb8129ee15a132004b19f9aa7280a6fa69e8333" => :mountain_lion
    sha256 "cc5793888804040fac2f4595896f862fc964409df9b37cc64a84579c80c18f45" => :lion
  end

  conflicts_with "gambit-scheme", :because => "both install `scheme-r5rs` binaries"
  conflicts_with "scsh", :because => "both install include/scheme48.h"

  def install
    ENV.O0 if ENV.compiler == :clang
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--enable-gc=bibop"
    system "make"
    system "make", "install"
  end
end
