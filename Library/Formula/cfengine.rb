class Cfengine < Formula
  homepage "https://cfengine.com/"
  url "https://s3.amazonaws.com/cfengine.package-repos/tarballs/cfengine-3.6.4.tar.gz"
  sha256 "0df910185e41004a5d9eeb91718d92583508efcf1d19df7caecc7d288dc5a933"

  bottle do
    cellar :any
    sha1 "143856c4d884af447e8c5b395ff5232745007a18" => :yosemite
    sha1 "784285e682e6b170bef1d36d8c60112a4b90bad5" => :mavericks
    sha1 "d38f9436790f4754cadc63bc0870b48c85901ea2" => :mountain_lion
  end

  resource "masterfiles" do
    url "https://s3.amazonaws.com/cfengine.package-repos/tarballs/masterfiles-3.6.4.tar.gz"
    sha256 "209e15b1ff83efd77e84a8f255679715d9a85ef171e205bc7dfed8867008ecdd"
  end

  depends_on "pcre"
  depends_on "lmdb"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libxml2" if MacOS.version < :mountain_lion
  depends_on "openssl"

  def install
    system "autoreconf", "-Wno-portability", "-fvi", "-I", "m4" # see autogen.sh
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-workdir=#{var}/cfengine",
                          "--with-lmdb=#{Formula["lmdb"].opt_prefix}",
                          "--with-pcre=#{Formula["pcre"].opt_prefix}",
                          "--without-mysql",
                          "--without-postgresql"
    system "make", "install"
    (share/"cfengine/CoreBase").install resource("masterfiles")
  end

  test do
    system "#{bin}/cf-agent", "-V"
  end
end
