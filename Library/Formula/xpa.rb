require 'formula'

class Xpa < Formula
  homepage 'http://hea-www.harvard.edu/RD/xpa/'
  url 'http://hea-www.harvard.edu/saord/download/xpa/xpa-2.1.15.tar.gz'
  sha1 '52f5cc2925f5ee6e642602d4405a240b32ade455'

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
