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
    revision 2
    sha256 "9b5c5a894bbb3988a4b6d9039eb107f3e46021d944eba03c666c3cbdfa20ec3a" => :yosemite
    sha256 "ae5c9ad2515591001a8e759c67bc23d2580ed429266c6fba4c8ddb4923dd9c89" => :mavericks
    sha256 "0fd532c961a5b677ff4975ed60d5c950d34e9fc079f493b45c7a0f30bda8f322" => :mountain_lion
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
