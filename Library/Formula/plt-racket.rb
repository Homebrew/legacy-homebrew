require 'formula'

class Racket < Formula
  homepage 'http://racket-lang.org/'
  url 'https://github.com/plt/racket/archive/v5.3.4.tar.gz'
  sha1 'a004f838744009c729dc34744846e09022c0f0d7'

  depends_on :xcode
  depends_on :x11
  depends_on :libpng

  def install
    cd "src" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}", "--enable-macprefix"
      system "make"
      system "make install"
    end
  end
end
