require "formula"

class Cmus < Formula
  homepage "https://cmus.github.io/"
  head "https://github.com/cmus/cmus.git"

  stable do
    url "https://github.com/cmus/cmus/archive/v2.5.1.tar.gz"
    sha1 "fd6c63c7cb405e4b4fea6a737074c454f602c202"
  end

  devel do
    url "https://github.com/cmus/cmus/archive/v2.6.0-rc0.tar.gz"
    version "2.6.0-rc0"
    sha1 "08f7f038d4fa14fe0e1b7dea5df137ada11401f3"
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
