require 'formula'

class Cfengine < Formula
  homepage 'http://cfengine.com/'
  url 'https://cfengine.com/source-code/download?file=cfengine-3.3.1.tar.gz'
  sha1 '254b1a5db2d4b01daf49455c9c9a5dac5b3f2fdb'

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
    system "#{bin}/cf-agent -V"
  end
end
