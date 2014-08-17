require 'formula'

class Libtar < Formula
  homepage 'http://repo.or.cz/w/libtar.git'
  url 'http://repo.or.cz/w/libtar.git/snapshot/v1.2.20.tar.gz'
  sha1 '3432cc24936d23f14f1e74ac1f77a1b2ad36dffa'

  bottle do
    cellar :any
    sha1 "a42c6dc4b8851f67f4d1bcff5e07262979a03327" => :mavericks
    sha1 "80c7eced65bfd68cf84f5ef5545c823aa979b1d3" => :mountain_lion
    sha1 "779f42e589701236029e0f40bda618d404da06a6" => :lion
  end

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
