require 'formula'

class Libiscsi < Formula
  homepage 'https://github.com/sahlberg/libiscsi'
  url 'https://sites.google.com/site/libiscsitarballs/libiscsitarballs/libiscsi-1.10.0.tar.gz'
  sha1 'b65de46e9a688078211c1ef8f8a5af2a828d71a6'
  head 'https://github.com/sahlberg/libiscsi.git'

  bottle do
    cellar :any
    sha1 "43778910dcf766e108c519f2a4faf41ae465c784" => :mavericks
    sha1 "d14714144c5d6b781cbc1437a497ab37b5c5695f" => :mountain_lion
    sha1 "6fda26d7c6f7bc60b6c11130809f7b02120aa317" => :lion
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
