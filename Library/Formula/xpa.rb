require 'formula'

class Xpa < Formula
  homepage 'http://hea-www.harvard.edu/RD/xpa/'
  url 'http://hea-www.harvard.edu/saord/download/xpa/xpa-2.1.15.tar.gz'
  sha1 'fe9df55606b663fbe01023fcd44a9c18bc7c6ad5'

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
