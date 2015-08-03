class Msktutil < Formula
  desc "Program for interoperability with Active Directory"
  homepage "https://code.google.com/p/msktutil/"
  url "https://msktutil.googlecode.com/files/msktutil-0.5.1.tar.bz2"
  sha256 "ec02f7f19aa5600c5d20f327beaef88ee70211841dc01fa42eb258ae840ae6f0"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
