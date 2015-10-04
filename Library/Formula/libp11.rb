class Libp11 < Formula
  desc "PKCS#11 wrapper library in C"
  homepage "https://github.com/OpenSC/libp11/wiki"
  url "https://downloads.sourceforge.net/project/opensc/libp11/libp11-0.2.8.tar.gz"
  sha256 "a4121015503ade98074b5e2a2517fc8a139f8b28aed10021db2bb77283f40691"
  revision 1

  bottle do
    cellar :any
    sha256 "1daf29346c2b73f53d9df61e42876f7d4c813389c0340e7b9385fb97b3e16a94" => :yosemite
    sha256 "2cb4d5a038448daee4c6c4078ea53afb88037645d8e28ef6a17e5644785f573d" => :mavericks
    sha256 "3853daccf8c51561cf882bb2f43e4b7a0ca70aebe9c9680b84f793bfe73d2a2e" => :mountain_lion
  end

  head do
    url "https://github.com/OpenSC/libp11.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "openssl"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
