class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.8.0.tar.gz"
  sha256 "21743034e3e3e0bea1faba956462079260e8486423eaa955e5f0e58d1ddf5088"

  bottle do
    cellar :any
    sha256 "9f385aae7fcd38256be3a72ce91fbcc1b86c6b3345b959db87161a75186134db" => :yosemite
    sha256 "b5ad2d8d0cb6f5c1be9bd3c8d27e7a3ca8b8bc0e266a60daed62fe7e671ad86a" => :mavericks
    sha256 "ede0bd07c38d96d290c74303e4469f5dfa3da29f23e539b67ea411c450f008ab" => :mountain_lion
  end

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.8.0.tar.gz"
    sha256 "6956ba4a359e8fe03b627b3fb16b382fed6e33cdfc303db08fb9790895c2a98e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libxml2" if MacOS.version < :mountain_lion
  depends_on "pcre"
  depends_on "lmdb"
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
    (pkgshare/"CoreBase").install resource("masterfiles")
  end

  test do
    assert_equal "CFEngine Core #{version}", shell_output("#{bin}/cf-agent -V").chomp
  end
end
