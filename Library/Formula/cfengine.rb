require 'formula'

class Cfengine < Formula
  homepage 'http://cfengine.com/'
  url 'http://s3.amazonaws.com/cfengine.package-repos/tarballs/cfengine-3.6.3.tar.gz'
  sha1 '90b5577bbeb6215e0ffbc19bf0fe6c2e01bda596'

  bottle do
    cellar :any
    sha1 "143856c4d884af447e8c5b395ff5232745007a18" => :yosemite
    sha1 "784285e682e6b170bef1d36d8c60112a4b90bad5" => :mavericks
    sha1 "d38f9436790f4754cadc63bc0870b48c85901ea2" => :mountain_lion
  end

  resource "masterfiles" do
    url "http://s3.amazonaws.com/cfengine.package-repos/tarballs/masterfiles-3.6.3.tar.gz"
    sha1 "23496c323ee9d8204d78a2047ef7a90c61d12b18"
  end

  depends_on 'pcre'
  depends_on 'lmdb'
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'libxml2' if MacOS.version < :mountain_lion
  depends_on "openssl"

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
    (share/"cfengine/CoreBase").install resource("masterfiles")
  end

  test do
    system "#{bin}/cf-agent", "-V"
  end
end
