require 'formula'

class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage 'https://github.com/libass/libass'
  url 'https://github.com/libass/libass/releases/download/0.12.2/libass-0.12.2.tar.gz'
  sha1 '416efe79a8529c246a4ed98c8698265a87ffa22a'

  bottle do
    cellar :any
    sha256 "06264f637a349f9229055e7d0f18b6ff1c360cef75f6376511bd20761880f00b" => :yosemite
    sha256 "30abe24a8426edd4e101fedbda934f46e63269da66e07dcff7057b90ca8621fb" => :mavericks
    sha256 "a8c24f02234dc48f1521924547b5957fa7341172f7c7199208d81c2a6a90339c" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'yasm' => :build

  depends_on 'freetype'
  depends_on 'fribidi'
  depends_on 'fontconfig'
  depends_on 'harfbuzz' => :optional

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
