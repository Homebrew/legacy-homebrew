require 'formula'

class CmuPocketsphinx < Formula
  url 'http://downloads.sourceforge.net/project/cmusphinx/pocketsphinx/0.6.1/pocketsphinx-0.6.1.tar.gz'
  homepage 'http://cmusphinx.sourceforge.net/'
  md5 'f5c737819b61a135dd0cc3cab573ae7a'

  depends_on 'pkg-config' => :build
  depends_on 'cmu-sphinxbase'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
