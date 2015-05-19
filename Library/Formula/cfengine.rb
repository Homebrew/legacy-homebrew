class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://s3.amazonaws.com/cfengine.package-repos/tarballs/cfengine-3.6.4.tar.gz"
  sha256 "0df910185e41004a5d9eeb91718d92583508efcf1d19df7caecc7d288dc5a933"

  bottle do
    cellar :any
    revision 1
    sha256 "6ef9ed9115344ac99db5a758541b83296ab493f15d9c0bee91852c46d80dfd71" => :yosemite
    sha256 "52619169e80a684b906e27d72c8af9c51b30e7821d2c225b7c0171dc2c2e38d2" => :mavericks
    sha256 "afc7ed7c92d3a2403add0ed4ae20fc28cba7d7cf060d477e9f2c48694c87efd7" => :mountain_lion
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
