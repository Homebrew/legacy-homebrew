require 'formula'

class Cocot < Formula
  homepage 'http://vmi.jp/software/cygwin/cocot.html'
  url 'https://github.com/vmi/cocot/archive/cocot-1.1-20120313.tar.gz'
  sha1 'ffc36f56e47c22a963ef48cb67e60b0337b58bc6'

  head 'https://github.com/vmi/cocot.git'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
