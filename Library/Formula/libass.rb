require 'formula'

class Libass < Formula
  homepage 'https://github.com/libass/libass'
  url 'https://github.com/libass/libass/releases/download/0.11.1/libass-0.11.1.tar.gz'
  sha1 '2a5517e634b3606c7dad5a42eae6ad8b23f8e097'

  depends_on 'pkg-config' => :build
  depends_on 'yasm' => :build

  depends_on :freetype
  depends_on 'fribidi'
  depends_on :fontconfig

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
