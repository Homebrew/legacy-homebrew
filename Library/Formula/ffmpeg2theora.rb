class Ffmpeg2theora < Formula
  desc "Convert video files to Ogg Theora format"
  homepage "http://v2v.cc/~j/ffmpeg2theora/"
  revision 1

  stable do
    url "http://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.29.tar.bz2"
    sha256 "214110e2a5afdd8ff8e0be18152e893dbff5dabc1ae1d1124e64d9f93eae946d"

    # Fixes build with ffmpeg 2.x by removing use of deprecated constant
    # Vendored because upstream's git repo "churns" and the checksum doesn't remain static.
    patch do
      url "https://raw.githubusercontent.com/DomT4/scripts/5f773bffa06/Homebrew_Resources/ffmpeg2theora/ffmpeg2theora.diff"
      sha256 "caf2863bf1da8f5eb78c07c2cfb9ee732a0373a0e177208c8a391e9525359cbc"
    end

    depends_on "libkate" => :optional
  end

  bottle do
    cellar :any
    revision 1
    sha1 "94fc80f71d14abe75e467c8d631e67ee51dbd685" => :yosemite
    sha1 "acf1a399ee26ae9b9303b649b1e405881da1664c" => :mavericks
    sha1 "7c215c1078da702b774e8f99787f9bd87975aedc" => :mountain_lion
  end

  head do
    url "https://git.xiph.org/ffmpeg2theora.git"

    depends_on "libkate" => :recommended
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "ffmpeg"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "theora"

  def install
    args = ["prefix=#{prefix}", "mandir=PREFIX/share/man"]
    scons "install", *args
  end

  test do
    system "#{bin}/ffmpeg2theora", "--help"
  end
end
