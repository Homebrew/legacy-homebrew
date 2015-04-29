class Freetds < Formula
  homepage "http://www.freetds.org/"
  url "ftp://ftp.freetds.org/pub/freetds/stable/freetds-0.91.112.tar.gz"
  sha256 "be4f04ee57328c32e7e7cd7e2e1483e535071cec6101e46b9dd15b857c5078ed"

  bottle do
    sha1 "7f98f1313e932185398c72237b7ac0d408cea986" => :mavericks
    sha1 "ecef51129ffd5d25543a9775960d5cea716bae78" => :mountain_lion
    sha1 "f261d6b8309af7642198ad87a2b63599a08602e3" => :lion
  end

  head do
    url "https://github.com/FreeTDS/freetds.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "with-msdblib", "Enable Microsoft behavior in the DB-Library API where it diverges from Sybase's"
  option "with-sybase-compat", "Enable close compatibility with Sybase's ABI, at the expense of other features"
  option "with-odbc-wide", "Enable odbc wide, prevent unicode - MemoryError's"
  option "with-krb5", "Enable Kerberos support"
  option "without-openssl", "Build without OpenSSL support (default is to use brewed OpenSSL)"

  deprecated_option "enable-msdblib" => "with-msdblib"
  deprecated_option "enable-sybase-compat" => "with-sybase-compat"
  deprecated_option "enable-odbc-wide" => "with-odbc-wide"
  deprecated_option "enable-krb" => "with-krb5"

  depends_on "pkg-config" => :build
  depends_on "unixodbc" => :optional
  depends_on "openssl" => :recommended

  def install
    system "autoreconf", "-i" if build.head?

    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.1
      --mandir=#{man}
    ]

    if build.with? "openssl"
      args << "--with-openssl=#{Formula["openssl"].opt_prefix}"
    end

    if build.with? "unixodbc"
      args << "--with-unixodbc=#{Formula["unixodbc"].prefix}"
    end

    # Translate formula's "--with" options to configuration script's "--enable"
    # options
    %w[msdblib sybase-compat odbc-wide krb5].each do |option|
      if build.with? option
        args << "--enable-#{option}"
      end
    end

    ENV.universal_binary if build.universal?
    system "./configure", *args
    system "make"
    ENV.j1 # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}/tsql", "-C"
  end
end
