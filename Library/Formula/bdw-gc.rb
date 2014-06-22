require "formula"

class BdwGc < Formula
  homepage "http://www.hboehm.info/gc/"
  url "http://www.hboehm.info/gc/gc_source/gc-7.4.2.tar.gz"
  sha1 "cd4a54620c38a2c361b3ee99dd134dbffb57c313"

  depends_on "pkg-config" => :build
  depends_on "libatomic_ops" => :build

  bottle do
    sha1 "ec34da6a822836bf96e450def06569a8809410a8" => :mavericks
    sha1 "84f85673490d30f0de336ddf8f4c3fd5495d1b18" => :mountain_lion
    sha1 "433a316925295305a006cefd6adb48244768bfe1" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cplusplus"
    system "make"
    system "make check"
    system "make install"
  end
end
