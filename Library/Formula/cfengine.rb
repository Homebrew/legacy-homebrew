require 'formula'

# https version doesn't download with system curl on Snow Leopard
# https://github.com/mxcl/homebrew/issues/20339
class Cfengine < Formula
  homepage 'http://cfengine.com/'
  url 'http://cfengine.com/source-code/download?file=cfengine-3.5.2.tar.gz'
  sha1 '57ffeee2a2a6acb1764a8a0d7979538d683ccf5a'

  depends_on 'pcre'
  depends_on 'tokyo-cabinet'
  depends_on 'libxml2' if MacOS.version < :mountain_lion

  def patches
    # Upstream patches for OS X compilation
    %w{
      https://github.com/cfengine/core/commit/f748a005b39a7aafd554e41a528b2216e28dce92.patch
      https://github.com/cfengine/core/commit/d03fcc2d38a4db0c79386aaef30597102bf45853.patch
      https://github.com/cfengine/core/commit/228f27002018a82b339ddfe6a5510a24128ce0ab.patch
    }
  end

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
