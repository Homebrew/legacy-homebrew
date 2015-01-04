require 'formula'

class Expat < Formula
  homepage 'http://expat.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/expat/expat/2.1.0/expat-2.1.0.tar.gz'
  sha1 'b08197d146930a5543a7b99e871cba3da614f6f0'
  revision 1

  bottle do
    cellar :any
    sha1 "94e147c1dd1016c67b5b6dad727b36cd64e9d210" => :yosemite
    sha1 "07aad05b79918e64e806e34b5656dc4caf9706fc" => :mavericks
    sha1 "b9c6747187fd1d38d207c5c40c94731a7a0b5a1e" => :mountain_lion
  end

  keg_only :provided_by_osx, "OS X includes Expat 1.5."

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
