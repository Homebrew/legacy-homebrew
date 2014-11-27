require 'formula'

class Cfengine < Formula
  homepage 'http://cfengine.com/'
  url 'http://s3.amazonaws.com/cfengine.package-repos/tarballs/cfengine-3.6.2.tar.gz'
  sha1 '036dae35dfce559f5807a13f4de2985f28d3e5d1'

  bottle do
    cellar :any
    sha1 "43ea51c13d9ce4cb4de2875d32ce6e389e3465af" => :yosemite
    sha1 "6cf3b0aa002c1a93702ed1687fa4d72aaa0f3a1d" => :mavericks
    sha1 "d6193124ee2324ed0cd279a6e8b47a95a586d5f7" => :mountain_lion
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
  end

  test do
    system "#{bin}/cf-agent", "-V"
  end
end
