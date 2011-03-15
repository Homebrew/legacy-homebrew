require 'formula'

class CmuPocketsphinx <Formula
  depends_on 'cmu-sphinxbase'
  url 'http://downloads.sourceforge.net/project/cmusphinx/pocketsphinx/0.6.1/pocketsphinx-0.6.1.tar.gz'
  homepage 'http://cmusphinx.sourceforge.net/'
  md5 'f5c737819b61a135dd0cc3cab573ae7a'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
