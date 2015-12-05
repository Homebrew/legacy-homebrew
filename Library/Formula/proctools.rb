class Proctools < Formula
  desc "pgrep, pkill, and pfind for OpenBSD and Darwin (OS X)"
  homepage "http://proctools.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/proctools/proctools/0.4pre1/proctools-0.4pre1.tar.gz"
  version "0.4pre1"
  sha256 "4553b9c6eda959b12913bc39b6e048a8a66dad18f888f983697fece155ec5538"

  depends_on "bsdmake" => :build

  # Patches via MacPorts
  {
    "pfind-Makefile"        => "d3ee204bbc708ee650b7310f58e45681c5ca0b3c3c5aa82fa4b402f7f5868b11",
    "pfind-pfind.c"         => "88f1bc60e3cf269ad012799dc6ddce27c2470eeafb7745bc5d14b78a2bdfbe96",
    "pgrep-Makefile"        => "f7f2bc21cab6ef02a89ee9e9f975d6a533d012b23720c3c22e66b746beb493fb",
    "pkill-Makefile"        => "bac12837958bc214234d47abe204ee6ad0da2d69440cf38b1e39ab986cc39d29",
    "proctools-fmt.c"       => "1a95516de3b6573a96f4ec4be933137e152631ad495f1364c1dd5ce3a9c79bc8",
    "proctools-proctools.c" => "1d08e570cc32ff08f8073308da187e918a89a783837b1ea20735ea25ae18bfdb",
    "proctools-proctools.h" => "7c2ee6ac3dc7b26fb6738496fbabb1d1d065302a39207ae3fbacb1bc3a64371a",
  }.each do |name, sha|
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/patches/f411d167/proctools/patch-#{name}.diff"
      sha256 sha
    end
  end

  def install
    system "bsdmake", "PREFIX=#{prefix}"

    ["pgrep/pgrep", "pkill/pkill", "pfind/pfind"].each do |prog|
      bin.install prog
      man1.install prog + ".1"
    end
  end
end
