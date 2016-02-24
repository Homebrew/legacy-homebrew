class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://hcs64.com/vgmstream.html"
  url "http://svn.code.sf.net/p/vgmstream/code", :revision => 1040
  version "r1040"

  bottle do
    cellar :any
    sha256 "314ab31528d85117117a4610a1f023b22686a565997357df92ceff52e4085013" => :yosemite
    sha256 "65522c757a6ce8392496e71279fa553074dc2b765d56a80b1709b58d1a56e704" => :mavericks
    sha256 "8e9771faf488616e96a159ee3d3681549f58ee240385c55f8a13be507e8a5a6a" => :mountain_lion
  end

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
