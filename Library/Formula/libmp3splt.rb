class Libmp3splt < Formula
  desc "Utility library to split mp3, ogg, and FLAC files"
  homepage "http://mp3splt.sourceforge.net"
  url "https://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.9.2/libmp3splt-0.9.2.tar.gz"
  sha256 "30eed64fce58cb379b7cc6a0d8e545579cb99d0f0f31eb00b9acc8aaa1b035dc"

  bottle do
    sha1 "c8c679d41172345360105247e20e6996d8ad8a6e" => :yosemite
    sha1 "9814ea3e104296b7c4deda3d7a548737b2abd605" => :mavericks
    sha1 "1be429bb92ffc593284b8f33456795f78c711a1e" => :mountain_lion
  end

  depends_on "libtool" => :run
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "pcre"
  depends_on "libid3tag"
  depends_on "mad"
  depends_on "libvorbis"
  depends_on "flac"
  depends_on "libogg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
