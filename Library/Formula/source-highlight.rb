require 'formula'

class SourceHighlight <Formula
  url 'http://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.4.tar.gz'
  homepage 'http://www.gnu.org/software/src-highlite/'
  md5 'becf8292b84ece6b532b0f0c92b530ee'

  depends_on 'boost'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
