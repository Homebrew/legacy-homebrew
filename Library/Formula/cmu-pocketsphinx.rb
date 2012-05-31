require 'formula'

class CmuPocketsphinx < Formula
  url 'http://sourceforge.net/projects/cmusphinx/files/pocketsphinx/0.7/pocketsphinx-0.7.tar.gz'
  homepage 'http://cmusphinx.sourceforge.net/'
  md5 '3c42d6fed086801240a329af57422f50'

  depends_on 'pkg-config' => :build
  depends_on 'cmu-sphinxbase'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
