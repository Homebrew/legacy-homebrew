require 'formula'

class Cfengine < Formula
  homepage 'http://cfengine.com/'
  url 'https://cfengine.com/source-code/download?file=cfengine-3.3.4.tar.gz'
  sha1 '143ab0000e39b9ba2fb0b00a0f0ce69608787423'

  depends_on 'tokyo-cabinet'
  depends_on 'pcre'

  def patches
    # See https://github.com/cfengine/core/commit/ce2b8abf
    "https://github.com/cfengine/core/commit/ce2b8abf.patch" if ENV.compiler == :clang
  end

  def install
    # Find our libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

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
