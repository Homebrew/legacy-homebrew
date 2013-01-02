require 'formula'

class Xpa < Formula
  homepage 'http://hea-www.harvard.edu/RD/xpa/'
  url 'http://hea-www.harvard.edu/saord/download/xpa/xpa-2.1.14.tar.gz'
  sha1 '927afc7beb90999cf63f75810d34a0ffead5f401'

  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    # relocate man, since --mandir is ignored
    mv "#{prefix}/man", man
  end
end
