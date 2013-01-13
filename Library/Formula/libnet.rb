require 'formula'

class Libnet < Formula
  homepage 'https://github.com/sam-github/libnet'
  url 'http://sourceforge.net/projects/libnet-dev/files/libnet-1.1.6.tar.gz'
  sha1 'dffff71c325584fdcf99b80567b60f8ad985e34c'

  # MacPorts does an autoreconf to get raw sockets working
  depends_on :automake
  depends_on :autoconf
  depends_on :libtool

  # Fix raw sockets support
  def patches
    {:p0 =>
     "https://trac.macports.org/export/95336/trunk/dports/net/libnet11/files/patch-configure.in.diff"
    }
  end

  def install
    # Compatibility with Automake 1.13 and newer.
    # Reported upstream:
    # https://github.com/sam-github/libnet/issues/28
    mv 'configure.in', 'configure.ac'
    inreplace 'configure.ac', 'AM_CONFIG_HEADER', 'AC_CONFIG_HEADERS'
    (buildpath/'m4').mkpath

    system "autoreconf --force --install"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    inreplace "src/libnet_link_bpf.c", "#include <net/bpf.h>", "" # Per MacPorts
    system "make install"
  end
end

