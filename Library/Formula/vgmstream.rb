require "formula"

class Vgmstream < Formula
  homepage "http://hcs64.com/vgmstream.html"
  url "http://svn.code.sf.net/p/vgmstream/code", :revision => 1040
  version "r1040"

  depends_on "mpg123"
  depends_on "libvorbis"

  def install
    cd "test" do
      system "make"
      bin.install "test" => "vgmstream"
      lib.install "../src/libvgmstream.a"
    end
  end
end
