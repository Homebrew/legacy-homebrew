require 'formula'

class Libass < Formula
  homepage 'https://github.com/libass/libass'
  url 'https://github.com/libass/libass/releases/download/0.12.2/libass-0.12.2.tar.gz'
  sha1 '416efe79a8529c246a4ed98c8698265a87ffa22a'

  bottle do
    cellar :any
    sha1 "8e9905cdb32977625f493b809371bf402d201f75" => :yosemite
    sha1 "a17cdbc03fcb4a4e59da362dedbcc8f0dbdae286" => :mavericks
    sha1 "d6040252dce55cf05bc1c7765877d25fadea81f4" => :mountain_lion
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
