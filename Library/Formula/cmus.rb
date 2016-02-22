class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.7.1.tar.gz"
  sha256 "8179a7a843d257ddb585f4c65599844bc0e516fe85e97f6f87a7ceade4eb5165"
  revision 1
  head "https://github.com/cmus/cmus.git"

  bottle do
    sha256 "c59774836e10d043d117b3a07193fc4eee97e37e11875fceea17980a067a7904" => :el_capitan
    sha256 "efaa6209f0fdfe5bfffa9a527a9c073ac202229e82484e96e5b539d17c283444" => :yosemite
    sha256 "15b3a9610c3b37808396787ced0f1cb5ae9b0dff30e6657419d46906229f5097" => :mavericks
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
  depends_on "jack" => :optional

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
