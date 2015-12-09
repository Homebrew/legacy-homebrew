class Lsdvd < Formula
  desc "Read the content info of a DVD"
  homepage "https://sourceforge.net/projects/lsdvd"
  url "https://downloads.sourceforge.net/project/lsdvd/lsdvd/0.16%20-%20I%20hate%20James%20Blunt/lsdvd-0.16.tar.gz"
  sha256 "04ae3e2d823ed427e31d57f3677d28ec36bdf3bf984d35f7bdfab030d89b20f1"

  bottle do
    cellar :any
    sha256 "29aa32a4b1b1c327aaea8b568f625c0c8e49723a3397d722df927e0b1b4493d7" => :el_capitan
    sha256 "9af38820e4747c002f38be75d31577533980ca731f12cffc2b9f41c6a37e1a3d" => :yosemite
    sha256 "b00f07a2636d1d73ab1b3456843d35de78e01f98f9ac818c4f0d70a88893253b" => :mavericks
  end

  depends_on "libdvdread"
  depends_on "libdvdcss" => :optional

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/cb1d457/lsdvd/patch-configure.diff"
    sha256 "3535ad1ad4c8fc2e49287190edcd89cd9d0679682ee94aca200252b9e1d80cd9"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/cb1d457/lsdvd/patch-lsdvd_c.diff"
    sha256 "33a8f5876a0aa09532424066da71c64d18ab67154ecbebd66f81d98843937079"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
