class Eg < Formula
  desc "Expert Guide. Norton Guide Reader For GNU/Linux"
  homepage "https://github.com/davep/eg"
  url "https://github.com/davep/eg/archive/eg-v1.01.tar.gz"
  sha256 "bb7a2af37c8d5d07f785466692f21561257ff99106d2cb91db13ba2e946ff13b"
  head "https://github.com/davep/eg.git"

  bottle do
    cellar :any
    sha256 "e8ab1c7a1d605b7b709730fbf80fd8fcd2bafa06a638f81dd2069efc6b104197" => :el_capitan
    sha256 "f47076de6f48d34d81e948a4fc48cab22de20ffe872a3100770d36a49a02a74d" => :yosemite
    sha256 "512ebd1293a80523e446893da92300b210b8beeafd424dc1dbd047d16543a1f1" => :mavericks
  end

  depends_on "s-lang"

  def install
    inreplace "eglib.c", "/usr/share/", "#{etc}/"
    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man}", "NGDIR=#{etc}/norton-guides"
  end

  test do
    # It will return a non-zero exit code when called with any option
    # except a filename, but will return success if the file doesn't
    # exist, without popping into the UI - we're exploiting this here.
    ENV["TERM"] = "xterm"
    system bin/"eg", "not_here.ng"
  end
end
