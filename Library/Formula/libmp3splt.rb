require "formula"

class Libmp3splt < Formula
  homepage "http://mp3splt.sourceforge.net"
  url "https://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.9.2/libmp3splt-0.9.2.tar.gz"
  sha1 "d4e84e1f466e7fdabe30d0a12acb751903bb9203"

  bottle do
    sha1 "c8c679d41172345360105247e20e6996d8ad8a6e" => :yosemite
    sha1 "9814ea3e104296b7c4deda3d7a548737b2abd605" => :mavericks
    sha1 "1be429bb92ffc593284b8f33456795f78c711a1e" => :mountain_lion
  end

  depends_on "libtool" => :build
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
