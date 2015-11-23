class Liblockfile < Formula
  desc "Library providing functions to lock standard mailboxes"
  homepage "https://tracker.debian.org/pkg/liblockfile"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libl/liblockfile/liblockfile_1.09.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libl/liblockfile/liblockfile_1.09.orig.tar.gz"
  sha256 "16979eba05396365e1d6af7100431ae9d32f9bc063930d1de66298a0695f1b7f"

  bottle do
    revision 2
    sha256 "e4d6ff7643eebb7fd6726176db9938b0e68526d53909a5cf3a2dd6aff1c1a378" => :el_capitan
    sha256 "1db90af0082d415223b928d477b6abe2047d9bad9b2f07991ad4eee3e5c0cde6" => :yosemite
    sha256 "279009f21a530b2350ddc0321e649fe90ff443480522b078e0f082398d740f24" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--with-mailgroup=staff",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
    bin.mkpath
    lib.mkpath
    include.mkpath
    man1.mkpath
    man3.mkpath
    system "make"
    system "make", "install"
  end

  test do
    system bin/"dotlockfile", "-l", "locked"
    assert File.exist?("locked")
    system bin/"dotlockfile", "-u", "locked"
    assert !File.exist?("locked")
  end
end
