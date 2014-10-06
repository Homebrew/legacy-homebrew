require "formula"

class Cmus < Formula
  homepage "https://cmus.github.io/"
  head "https://github.com/cmus/cmus.git"
  url "https://github.com/cmus/cmus/archive/v2.6.0.tar.gz"
  sha1 "aba00eb75335532c0413f7c819c2e2d12fcd4314"
  revision 1

  bottle do
    sha1 "584b513eda4887a001a6a4613160f1181620ba94" => :mavericks
    sha1 "b7ff43fa726aff8d9e26f7dbf1d2c136cb416910" => :mountain_lion
    sha1 "5b455c2550115d65edb2b1ee537b0bdbfd62384e" => :lion
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
