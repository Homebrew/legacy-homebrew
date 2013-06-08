require 'formula'

class Cfengine < Formula
  homepage 'http://cfengine.com/'
  url 'https://cfengine.com/source-code/download?file=cfengine-3.4.4.tar.gz'
  sha1 'f99174fcb358a263b1a1090668d7ba2ba849bbc1'

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
