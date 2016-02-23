class Nvi < Formula
  desc "44BSD re-implementation of vi"
  homepage "https://sites.google.com/a/bostic.com/keithbostic/vi/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/n/nvi/nvi_1.81.6.orig.tar.gz"
  sha256 "8bc348889159a34cf268f80720b26f459dbd723b5616107d36739d007e4c978d"

  bottle do
    cellar :any
    sha256 "75ea5ae632a340cd15118c9fa9134ef750e3e2b0d5dae54f7725e9786ed9f924" => :el_capitan
    sha256 "81c395ade5bad8e89edd06ba70bde4075801b3bd4f67a79df4719628f788d8a0" => :yosemite
    sha256 "ff4b8ae7f70172d31e7f2983cb91d5e4ea946ce66dbca50ae5af30158de70862" => :mavericks
  end

  depends_on "berkeley-db"

  # Patches per MacPorts
  # The first corrects usage of BDB flags.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/8ef45e8b/nvi/patch-common__db.h"
    sha256 "d6c67a129cec0108a0c90fd649d79de65099dc627b10967a1fad51656f519800"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/8ef45e8b/nvi/patch-dist__port.h.in"
    sha256 "674adb27810da8f6342ffc912a54375af0ed7769bfa524dce01600165f78a63b"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/8ef45e8b/nvi/patch-ex_script.c.diff"
    sha256 "742c4578319ddc07b0b86482b4f2b86125026f200749e07c6d2ac67976204728"
  end

  # support berkeley > 4, patch extracted from debian package
  # http://http.debian.net/debian/pool/main/n/nvi/nvi_1.81.6-11.debian.tar.gz
  patch do
    url "https://gist.githubusercontent.com/nijikon/c77bd170ff76dfe6cea4/raw/76369bda9d345c8d027766c4f892a5c82de0f493/nvi-db4.patch"
    sha256 "33f707366757cc83dddf39251f64b45d6549a07ad21bc0fcc66ed6fc5d2b3964"
  end

  def install
    cd "dist" do
      system "./configure", "--prefix=#{prefix}",
                            "--program-prefix=n",
                            "--disable-dependency-tracking"
      system "make"
      ENV.j1
      system "make", "install"
    end
  end
end
