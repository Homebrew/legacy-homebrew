require 'formula'

class Vde < Formula
  homepage 'http://vde.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/vde/vde2/2.3.2/vde2-2.3.2.tar.gz'
  sha256 '22df546a63dac88320d35d61b7833bbbcbef13529ad009c7ce3c5cb32250af93'

  def install
    system "./configure", "--prefix=#{prefix}"
    # 2.3.1 built in parallel but 2.3.2 does not. See:
    # https://sourceforge.net/tracker/?func=detail&aid=3501432&group_id=95403&atid=611248
    ENV.j1
    system "make install"
  end
end
