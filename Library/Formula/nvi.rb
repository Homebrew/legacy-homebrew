class Nvi < Formula
  desc "44BSD re-implementation of vi"
  homepage "https://sites.google.com/a/bostic.com/keithbostic/vi/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/n/nvi/nvi_1.81.6.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/n/nvi/nvi_1.81.6.orig.tar.gz"
  sha256 "8bc348889159a34cf268f80720b26f459dbd723b5616107d36739d007e4c978d"
  revision 1

  bottle do
    cellar :any
    sha256 "c4f15ed7ef7d6ca867cccf614823d03a0ffebfd1c303ae2625f64645b4b36b62" => :el_capitan
    sha256 "2b6a728e143b8dbd0584d403e5c7b5138130a09177bd658ba3dc95f999420ddd" => :yosemite
    sha256 "b86a3fc268f0b698e8218505bc257256d36c79f215e19fbaa72c8970995c402e" => :mavericks
  end

  depends_on "xz" => :build # Homebrew bug. Shouldn't need declaring explicitly.
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

  # Upstream have been pretty inactive for a while, so we may want to kill this
  # formula at some point unless that changes. We're leaning hard on Debian now.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/n/nvi/nvi_1.81.6-12.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/n/nvi/nvi_1.81.6-12.debian.tar.xz"
    sha256 "c86c9feac8410ffbf79bb8ddf85b34d2edcc00660d8f4cd131eb65e8e0d6156b"
    apply "patches/03db4.patch",
          "patches/19include_term_h.patch",
          "patches/24fallback_to_dumb_term.patch",
          "patches/26trailing_tab_segv.patch",
          "patches/27support_C_locale.patch"
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
