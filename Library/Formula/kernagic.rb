require 'formula'

class Kernagic < Formula
  homepage 'https://github.com/hodefoting/kernagic/'
  url 'https://github.com/hodefoting/kernagic/archive/0.1.zip'
  sha1 'e79bce36b72d8645b3923f551160e05636e3fb32'
  head 'https://github.com/hodefoting/kernagic.git'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'gtk+'

  def install
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/kernagic -h"
  end
end
