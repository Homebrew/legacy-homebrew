require 'formula'

class Mlkit < Formula
  homepage 'http://sourceforge.net/apps/mediawiki/mlkit'
  url 'http://sourceforge.net/projects/mlkit/files/mlkit-4.3.7/mlkit-4.3.7.tgz'
  sha1 '7c1f69f0cde271f50776d33b194699b403bab598'

  depends_on :autoconf => :build
  depends_on 'mlton' => :build
  depends_on 'gmp'
  depends_on :tex

  def install
    system "./autobuild; true"
    system "./configure", "--prefix=#{prefix}"
    ENV.m32
    system "make mlkit"
    system "make mlkit_libs"
    system "make install"
  end

  test do
    system "mlkit -V"
  end
end
