class Msktutil < Formula
  desc "Program for interoperability with Active Directory"
  homepage "https://sourceforge.net/projects/msktutil/"
  url "https://downloads.sourceforge.net/project/msktutil/msktutil-1.0rc2.tar.bz2"
  sha256 "07884a98fd86dfb704dc6302a56fcf2ccb3d8a34fb95dcb00e5e86428d91103b"

  def install
    system "./configure", "--disable-debug",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
