require "formula"

class Gabedit < Formula
  homepage "http://gabedit.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gabedit/gabedit/Gabedit248/GabeditSrc248.tar.gz"
  version "2.4.8"
  sha1 "7a48f42c39258471faa0a3942890c16b6290de41"

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtkglext"

  def install
    args = []
    args << "OMPLIB=" << "OMPCFLAGS=" if ENV.compiler == :clang
    system "make", *args
    bin.install "gabedit"
  end
end
