require 'formula'

class Cfengine < Formula
  homepage 'http://cfengine.com/'
  url 'http://s3.amazonaws.com/cfengine.package-repos/tarballs/cfengine-3.6.1.tar.gz'
  sha1 '719608b87836b0b4d05685c3ce67c3fad8a3173a'

  depends_on 'pcre'
  depends_on 'lmdb'
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'libxml2' if MacOS.version < :mountain_lion

  def install
    system "autoreconf", "-Wno-portability", "-fvi", "-I", "m4" # see autogen.sh
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-workdir=#{var}/cfengine",
                          "--with-lmdb=#{Formula['lmdb'].opt_prefix}",
                          "--with-pcre=#{Formula['pcre'].opt_prefix}",
                          "--without-mysql",
                          "--without-postgresql"
    system "make install"
  end

  test do
    system "#{bin}/cf-agent", "-V"
  end
end
