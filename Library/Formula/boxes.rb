class Boxes < Formula
  desc "Draw boxes around text"
  homepage "http://boxes.thomasjensen.com/"
  url "https://github.com/ascii-boxes/boxes/archive/v1.1.2.tar.gz"
  sha256 "4d5e536be91b476ee48640bef9122f3114b16fe2da9b9906947308b94682c5fe"
  head "https://github.com/ascii-boxes/boxes.git"

  bottle do
    revision 1
    sha256 "d5a5b256a1ef58a8d9c3d69c57c27bb8dd5c5e40e8979f877f83278ff38fd950" => :el_capitan
    sha256 "ee8b2795856fafcfaad79356325d7e1cf6aaa02359cb9adf162df2028243f429" => :yosemite
    sha256 "4d82f6e37b1e18d48a2198ca4301d901e4a6b55681ed8f0b65dddeee1148221e" => :mavericks
  end

  def install
    ENV.m32

    # distro uses /usr/share/boxes change to prefix
    system "make",
      "GLOBALCONF=#{share}/boxes-config",
      "CC=#{ENV.cc}",
      # Force 32 bit compile
      "CFLAGS_ADDTL=-m32",
      "LDFLAGS_ADDTL=-m32"

    bin.install "src/boxes"
    man1.install "doc/boxes.1"
    share.install "boxes-config"
  end

  test do
    assert_match "/* test brew */", pipe_output("#{bin}/boxes", "test brew")
  end
end
