class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.7.1.tar.gz"
  sha256 "8179a7a843d257ddb585f4c65599844bc0e516fe85e97f6f87a7ceade4eb5165"
  head "https://github.com/cmus/cmus.git"

  bottle do
    sha256 "4c85eeaae475c91cb94c1bf8e7c05959f3291c718a9ad75aac5a3e47f993a62b" => :el_capitan
    sha256 "f4270eee31bc7c8ef97b1ae000f08d2a023c52e1088b2061ba3553546405b4f2" => :yosemite
    sha256 "6df496b6de1ff930667217e4a8d5076bb0b89e171c9d6f0dd3566840daba0d46" => :mavericks
    sha256 "b35d34f834f02e8e21611ade71a67dbbdbd0f1ffc4286279939e6f30f2767f28" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "mad"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "faad2"
  depends_on "flac"
  depends_on "mp4v2"
  depends_on "libcue"
  depends_on "ffmpeg" => :optional
  depends_on "opusfile" => :optional

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
