require 'formula'

class Chmlib < Formula
  homepage 'http://www.jedrea.com/chmlib'
  url 'http://www.jedrea.com/chmlib/chmlib-0.40.tar.gz'
  sha1 '8d9e4b9b79a23974aa06fb792ae652560bac5c4e'

  bottle do
    cellar :any
    sha1 "e65fbdafd130028ed1383a8318612917e6f4eda5" => :mavericks
    sha1 "bd7d91259ed29e4fd804ef8ae45ab57ac1559da8" => :mountain_lion
    sha1 "cc6c36eca6407cfaa925aca3c86dc875adc7566a" => :lion
  end

  def install
    system "./configure", "--disable-io64", "--enable-examples", "--prefix=#{prefix}"
    system "make install"
  end
end
