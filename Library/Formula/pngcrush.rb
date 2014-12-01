require "formula"

class Pngcrush < Formula
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.7.81/pngcrush-1.7.81.tar.gz"
  sha1 "c5f4c2aeb7b15b8bb49df7e66d7c1a7843cb39f8"

  bottle do
    cellar :any
    sha1 "53f7387c74770525785c8c8db39ce68eaf0d8a27" => :yosemite
    sha1 "293bcf3d61802bb66c3d89f0ab43f320668c0c2b" => :mavericks
    sha1 "5a0151c3adfb20300a85702189a87cfd8ae5a411" => :mountain_lion
  end

  def install
    # Required to enable "-cc" (color counting) option (disabled by default since 1.5.1)
    ENV.append_to_cflags "-DPNGCRUSH_COUNT_COLORS"

    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}"
    bin.install "pngcrush"
  end

  test do
    system "#{bin}/pngcrush", test_fixtures("test.png"), "/dev/null"
  end
end
