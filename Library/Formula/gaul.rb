require 'formula'

class Gaul < Formula
  url 'http://downloads.sourceforge.net/project/gaul/gaul-devel/0.1850-0/gaul-devel-0.1850-0.tar.gz'
  homepage 'http://gaul.sourceforge.net/'
  md5 '3a832c882b0df0f5c46f733d360fd7bb'
  version '0.1850'

  depends_on 's-lang'

  def install
    # disabling slang is necessary
    # http://www.pgrouting.org/docs/1.x/install_freebsd.html
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-slang"
    system "make install"
  end

  def patch
    # cf. http://www.pgrouting.org/docs/1.x/install_freebsd.html
    "https://gist.github.com/raw/1271339/d58fc59d16649170bb267c8d1607054c6b960f03/gaul-mac-os-x.patch"
  end
end
