require 'formula'

class Libiscsi < Formula
  homepage 'https://github.com/sahlberg/libiscsi'
  url 'https://sites.google.com/site/libiscsitarballs/libiscsitarballs/libiscsi-1.10.0.tar.gz'
  sha1 'b65de46e9a688078211c1ef8f8a5af2a828d71a6'
  head 'https://github.com/sahlberg/libiscsi.git'

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
