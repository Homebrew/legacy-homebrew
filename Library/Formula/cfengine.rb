require 'formula'

# https version doesn't download with system curl on Snow Leopard
# https://github.com/mxcl/homebrew/issues/20339
class Cfengine < Formula
  homepage 'http://cfengine.com/'
  url 'http://cfengine.com/source-code/download?file=cfengine-3.5.0.tar.gz'
  sha1 'bddb179b5015d4d9d45fba3c2e63ca764bc46bf3'

  depends_on 'pcre'
  depends_on 'tokyo-cabinet'

  def install
    # Find our libpcre
    ENV.append 'LDFLAGS', "-L#{Formula.factory('pcre').opt_prefix}/lib"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-workdir=#{var}/cfengine",
                          "--with-tokyocabinet"
    system "make install"
  end

  def test
    system "#{bin}/cf-agent", "-V"
  end
end
