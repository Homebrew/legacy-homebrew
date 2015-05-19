require 'formula'

class Msktutil < Formula
  desc "Program for interoperability with Active Directory"
  homepage 'https://code.google.com/p/msktutil/'
  url 'https://msktutil.googlecode.com/files/msktutil-0.5.1.tar.bz2'
  sha1 '26cceb7dcad17d73bf9fc1f6a3fef9298e465c91'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
