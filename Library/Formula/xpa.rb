require 'formula'

class Xpa < Formula
  homepage 'http://hea-www.harvard.edu/RD/xpa/'
  url 'http://hea-www.harvard.edu/saord/download/xpa/xpa-2.1.13.tar.gz'
  md5 '052053e329a8a03fa6f512f9aadf4828'

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
