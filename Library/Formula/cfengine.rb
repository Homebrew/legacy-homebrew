require 'formula'

# https version doesn't download with system curl on Snow Leopard
# https://github.com/Homebrew/homebrew/issues/20339
class Cfengine < Formula
  homepage 'http://cfengine.com/'
  url 'http://cfengine.com/source-code/download?file=cfengine-3.5.3.tar.gz'
  sha1 '95a03e7bc9e31704d6aac4b3023b9c5037fc33f6'

  depends_on 'pcre'
  depends_on 'tokyo-cabinet'
  depends_on 'libxml2' if MacOS.version < :mountain_lion

  # Upstream patches for OS X compilation
  patch do
    url "https://github.com/cfengine/core/commit/d03fcc2d38a4db0c79386aaef30597102bf45853.diff"
    sha1 "1050a7f1719b8ad0e04868319324cc38637a3725"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-workdir=#{var}/cfengine",
                          "--with-tokyocabinet",
                          "--with-pcre=#{Formula['pcre'].opt_prefix}",
                          "--without-mysql",
                          "--without-postgresql"
    system "make install"
  end

  test do
    system "#{bin}/cf-agent", "-V"
  end
end
