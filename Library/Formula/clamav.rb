class Clamav < Formula
  desc "Anti-virus software"
  homepage "http://www.clamav.net/"
  url "https://downloads.sourceforge.net/clamav/clamav-0.98.7.tar.gz"
  sha256 "282417b707740de13cd8f18d4cbca9ddd181cf96b444db2cad98913a5153e272"
  revision 1

  bottle do
    revision 1
    sha256 "3cb914d89c96effdf0439551f1dd150144cfaab5f18e22a104da97aba36f8ece" => :el_capitan
    sha256 "547d8ef72bee7b5c28a1da1b06b93a7720405fe5a5804bbff2b8f5e80a8df0af" => :yosemite
    sha256 "e7797dd35b4e5a10eda9e183741cb8f7ace847ddc9179de098dad71b0c952e58" => :mavericks
  end

  head do
    url "https://github.com/vrtadmin/clamav-devel.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"
  depends_on "json-c" => :optional

  skip_clean "share/clamav"

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--libdir=#{lib}",
      "--sysconfdir=#{etc}/clamav",
      "--disable-zlib-vcheck",
      "--with-zlib=#{MacOS.sdk_path}/usr",
      "--with-openssl=#{Formula["openssl"].opt_prefix}",
      "--enable-llvm=no",
    ]

    args << "--with-libjson=#{Formula["json-c"].opt_prefix}" if build.with? "json-c"

    (share/"clamav").mkpath
    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    To finish installation & run clamav you will need to edit
    the example conf files at #{etc}/clamav/
    EOS
  end

  test do
    system "#{bin}/clamav-config", "--version"
  end
end
