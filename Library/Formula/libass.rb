require 'formula'

class Libass < Formula
  homepage 'https://github.com/libass/libass'
  url 'https://github.com/libass/libass/releases/download/0.12.1/libass-0.12.1.tar.gz'
  sha1 'ddf61cf8e15fea7825667580b207d46fe34bd4ac'

  bottle do
    cellar :any
    sha1 "98df8bd8495502eb83c4691d5437f4e8bfd82995" => :yosemite
    sha1 "d1fed43287b619485d89245980b3b00858874a90" => :mavericks
    sha1 "912213b24af3951e61f5ab4c94f709fe4640f08f" => :mountain_lion
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
