require 'formula'

class Libiscsi < Formula
  desc "Client library and utilities for iscsi"
  homepage 'https://github.com/sahlberg/libiscsi'
  url 'https://sites.google.com/site/libiscsitarballs/libiscsitarballs/libiscsi-1.10.0.tar.gz'
  sha1 'b65de46e9a688078211c1ef8f8a5af2a828d71a6'
  head 'https://github.com/sahlberg/libiscsi.git'

  bottle do
    cellar :any
    revision 1
    sha1 "5bc5b53461a7564d9721c7b468d37fbdbae564a2" => :yosemite
    sha1 "e53c4947c7747b1d4cd1e9f36c88a16e200c4866" => :mavericks
    sha1 "2edaf3c3a74dcb17365ef51d8d460939f0a5594c" => :mountain_lion
  end

  option 'with-noinst', 'Install the noinst binaries (e.g. iscsi-test-cu)'

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cunit" if build.with? "noinst"
  depends_on "popt"

  def install
    if build.with? 'noinst'
      # Install the noinst binaries
      inreplace 'Makefile.am', 'noinst_PROGRAMS +=', 'bin_PROGRAMS +='
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
