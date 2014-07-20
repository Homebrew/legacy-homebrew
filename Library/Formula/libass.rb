require 'formula'

class Libass < Formula
  homepage 'https://github.com/libass/libass'
  url 'https://github.com/libass/libass/releases/download/0.11.2/libass-0.11.2.tar.gz'
  sha1 'cd9df9000b5a303be56b66fef7497a8ff60ad844'

  bottle do
    cellar :any
    sha1 "f18d9921c8b5ec717683190a7d5dbc0daf79f9aa" => :mavericks
    sha1 "dbf8931620ff7f90cb6628ee5bc1844394d4bbeb" => :mountain_lion
    sha1 "9f4917a41524345f0ec112e1721cbd0777e015c6" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'yasm' => :build

  depends_on 'freetype'
  depends_on 'fribidi'
  depends_on 'fontconfig'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
