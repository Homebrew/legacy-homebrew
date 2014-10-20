require 'formula'

class Libass < Formula
  homepage 'https://github.com/libass/libass'
  url 'https://github.com/libass/libass/releases/download/0.11.2/libass-0.11.2.tar.gz'
  sha1 'cd9df9000b5a303be56b66fef7497a8ff60ad844'

  bottle do
    cellar :any
    revision 1
    sha1 "b621e1dad019a1673a3a7c8adeada48e4345f037" => :yosemite
    sha1 "99a59ed640f503ccfdc26887eebc3b01419538fb" => :mavericks
    sha1 "79b371cd8cab6d82b99569ec9184689b73cd7849" => :mountain_lion
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
