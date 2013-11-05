require 'formula'

class Kernagic < Formula
  homepage 'https://github.com/hodefoting/kernagic/'
  url 'https://github.com/hodefoting/kernagic/archive/v0.2.tar.gz'
  sha1 '6099408fc9ebe22936b048364a8fcd7b5b66a1d8'
  head 'https://github.com/hodefoting/kernagic.git'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'gtk+'

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/kernagic -h"
  end
end
