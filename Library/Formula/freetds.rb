class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "http://www.freetds.org/"
  url "ftp://ftp.freetds.org/pub/freetds/stable/freetds-0.95.19.tar.gz"
  mirror "https://fossies.org/linux/privat/freetds-0.95.19.tar.gz"
  sha256 "4c847f0c43734489ffc6ea8c5eb66e2a24e7a1ba4287acd24b2950f8b2eb7590"

  bottle do
    sha256 "00fb9daeb14892d7de89ee1fbf0612f49da34d8047315ff6a11725c785aaf34e" => :el_capitan
    sha256 "46c8bd1ddb9ba17f2245ddb138e8bf73bcb48c38e650d79d4838a52d027b5cd0" => :yosemite
    sha256 "0705eee494de88ffd20a3df3510d67251189119e2dc8a42ba11a2a1768252803" => :mavericks
    sha256 "1612e4ecf101341ce1ea78d195ab7b94641e04b20fedf376e854aef163526a6b" => :mountain_lion
  end

  head do
    url "https://github.com/FreeTDS/freetds.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "with-msdblib", "Enable Microsoft behavior in the DB-Library API where it diverges from Sybase's"
  option "with-sybase-compat", "Enable close compatibility with Sybase's ABI, at the expense of other features"
  option "with-odbc-wide", "Enable odbc wide, prevent unicode - MemoryError's"
  option "with-krb5", "Enable Kerberos support"

  deprecated_option "enable-msdblib" => "with-msdblib"
  deprecated_option "enable-sybase-compat" => "with-sybase-compat"
  deprecated_option "enable-odbc-wide" => "with-odbc-wide"
  deprecated_option "enable-krb" => "with-krb5"

  depends_on "pkg-config" => :build
  depends_on "unixodbc" => :optional
  depends_on "openssl" => :recommended

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.1
      --mandir=#{man}
    ]

    if build.with? "openssl"
      args << "--with-openssl=#{Formula["openssl"].opt_prefix}"
    end

    if build.with? "unixodbc"
      args << "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}"
    end

    # Translate formula's "--with" options to configuration script's "--enable"
    # options
    %w[msdblib sybase-compat odbc-wide krb5].each do |option|
      if build.with? option
        args << "--enable-#{option}"
      end
    end

    ENV.universal_binary if build.universal?

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make"
    ENV.j1 # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}/tsql", "-C"
  end
end
