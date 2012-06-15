require 'formula'

class Par2 < Formula
  homepage 'http://parchive.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/parchive/par2cmdline/0.4/par2cmdline-0.4.tar.gz'
  sha1 '2fcdc932b5d7b4b1c68c4a4ca855ca913d464d2f'

  def patches
    "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/app-arch/par2cmdline/files/par2cmdline-0.4-gcc4.patch?revision=1.1"
  end

  fails_with :clang do
    build 318
    cause "./par2fileformat.h:87:25: error: flexible array member 'entries' of non-POD element type 'FILEVERIFICATIONENTRY []'"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
