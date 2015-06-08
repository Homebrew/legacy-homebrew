require "formula"

class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  head "https://github.com/cmus/cmus.git"
  url "https://github.com/cmus/cmus/archive/v2.6.0.tar.gz"
  sha1 "aba00eb75335532c0413f7c819c2e2d12fcd4314"
  revision 1

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

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make install"
  end
end
