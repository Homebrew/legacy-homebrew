require 'formula'

class Cfengine < Formula
  homepage 'http://cfengine.com/'
  url 'http://s3.amazonaws.com/cfengine.package-repos/tarballs/cfengine-3.6.0.tar.gz'
  sha1 '6358981f836c8e09da154290b1f4285d3dc9562c'

  depends_on 'pcre'
  depends_on 'tokyo-cabinet'
  depends_on 'libxml2' if MacOS.version < :mountain_lion

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
