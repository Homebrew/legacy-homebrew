require 'formula'

class Kernagic < Formula
  homepage 'https://github.com/hodefoting/kernagic/'
  url 'https://github.com/hodefoting/kernagic/archive/0.1.zip'
  sha1 '671e4ff489c2357e718ea999f9b3d15779ae9a80'
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
