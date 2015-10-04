class Cattle < Formula
  desc "Brainfuck language toolkit"
  homepage "https://github.com/andreabolognani/cattle"
  url "https://github.com/andreabolognani/cattle/archive/cattle-1.2.0.tar.gz"
  sha256 "ff0b424011c56f61cb463f1d3fb32e58e40da41260298c407bd0748eb506468d"
  head "https://github.com/andreabolognani/cattle.git"

  bottle do
    sha256 "b646d326fa499931ae7ef731fa6fce4232239fce1d7f5b217b109ceafd784153" => :yosemite
    sha256 "4778f55a4ac08e5bf3f9402a37a5c6d97747ee16425325fa3a7fcda69034429d" => :mavericks
    sha256 "798aa25810d5dbfa2526cf0edf9117798b311c6ae6ce42b3a05c0bc90d087125" => :mountain_lion
  end

  # https://github.com/andreabolognani/cattle/issues/2
  patch do
    url "https://github.com/andreabolognani/cattle/pull/3.diff"
    sha256 "876802fd965050d95e9cd7836b71a3cac5cd2508bf7f45b17192803a6fe19c17"
  end

  depends_on "gtk-doc" => :build
  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    inreplace "autogen.sh", "libtoolize", "glibtoolize"

    system "sh", "autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
