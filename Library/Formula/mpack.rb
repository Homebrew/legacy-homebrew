require 'formula'

class Mpack < Formula
  homepage 'http://ftp.andrew.cmu.edu/pub/mpack/'
  url 'http://ftp.andrew.cmu.edu/pub/mpack/mpack-1.6.tar.gz'
  sha1 '7fd3a73e0f131412920b6ff34872e7e7fa03e03b'

  # Fix missing return value; clang refuses to compile otherwise
  def patches
    {:p0 => [
    "https://trac.macports.org/export/96943/trunk/dports/mail/mpack/files/uudecode.c.patch"
    ]}
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
