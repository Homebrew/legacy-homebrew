class Ffmpeg2theora < Formula
  desc "Convert video files to Ogg Theora format"
  homepage "http://v2v.cc/~j/ffmpeg2theora/"
  revision 1

  stable do
    url "http://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.29.tar.bz2"
    sha256 "214110e2a5afdd8ff8e0be18152e893dbff5dabc1ae1d1124e64d9f93eae946d"

    # Fixes build with ffmpeg 2.x by removing use of deprecated constant
    patch do
      url "https://git.xiph.org/?p=ffmpeg2theora.git;a=commitdiff_plain;h=d3435a6a83dc656379de9e6523ecf8d565da6ca6"
      sha256 "0655ed219b438d1eefd8ad31fad3c1b8da77f13b911eb6247466ac46ce060f3c"
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
