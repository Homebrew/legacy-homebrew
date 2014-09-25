require "formula"

class Libtrace < Formula
  homepage "http://research.wand.net.nz/software/libtrace.php"
  url "http://research.wand.net.nz/software/libtrace/libtrace-3.0.21.tar.bz2"
  sha1 "208908ceee0dde9a556dc4cf1d5dac7320f6bae3"

  bottle do
    sha1 "aed7a85b453b452ca98c55b8d6c534f7aeea283a" => :mavericks
    sha1 "578e479abb34754a0a6ceee8e9f20cafdce09a47" => :mountain_lion
    sha1 "673b919a3da93e90bfbd25e2401507a9d2cc434e" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
