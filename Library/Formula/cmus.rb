class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.7.0.tar.gz"
  sha256 "ad4bbc6828f162d56f7f2d61e60714df8f1006a2000cc7e2b867ba93352997e9"
  head "https://github.com/cmus/cmus.git"

  bottle do
    sha1 "da0f9ffb5fc18e25f5f3d9dafebdc24c5121a89e" => :mavericks
    sha1 "c59670990bc5055fae97c62732e6c4162b78e64c" => :mountain_lion
    sha1 "4bba9a8ce200e9ab6348bcc87f459ad328d5862c" => :lion
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

  # upstream commit to create the config directory if it doesn't exist instead
  # of failing. Remove this when upgrading to >2.7.0
  patch do
    url "https://github.com/cmus/cmus/commit/ce7e936f7161c6304056864c108c94a9a5d96589.diff"
    sha256 "c5bb8aa3a89336a5149ecc3826879d4da3b479bc661bfa819d59f5d6fae7e958"
  end

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
