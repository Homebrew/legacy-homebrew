require 'formula'

class Odt2txt < Formula
  # Retrieve the HEAD because no releases have been made since the commit that
  # includes Makefile rules for Mac OS X.
  head 'git://repo.or.cz/odt2txt.git'
  homepage 'http://stosberg.net/odt2txt/'

  def install
    # the build flags in the Makefile contain "/opt" paths
    args = ["CC=#{ENV.cc}",
            "CFLAGS=#{ENV.cflags}",
            "LDFLAGS=#{ENV.cppflags}",
            "DESTDIR=#{prefix}"]

    # Use the -B flag to force make the install target to circumvent bugs in the Makefile
    system "make", "-B", "install", *args
  end
end
