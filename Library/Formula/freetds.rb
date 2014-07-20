require 'formula'

class Freetds < Formula
  homepage 'http://www.freetds.org/'
  url 'http://mirrors.ibiblio.org/freetds/stable/freetds-0.91.tar.gz'
  sha1 '3ab06c8e208e82197dc25d09ae353d9f3be7db52'

  head do
    url 'https://git.gitorious.org/freetds/freetds.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  option :universal
  option "enable-msdblib", "Enable Microsoft behavior in the DB-Library API where it diverges from Sybase's"
  option "enable-sybase-compat", "Enable close compatibility with Sybase's ABI, at the expense of other features"
  option "enable-odbc-wide", "Enable odbc wide, prevent unicode - MemoryError's"
  option "enable-krb", "Enable Kerberos support"

  depends_on "pkg-config" => :build
  depends_on "unixodbc" => :optional
  depends_on "openssl"

  def install
    system "autoreconf -i" if build.head?

    args = %W[
      --prefix=#{prefix}
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-tdsver=7.1
      --mandir=#{man}
    ]

    if build.with? "unixodbc"
      args << "--with-unixodbc=#{Formula['unixodbc'].prefix}"
    end

    if build.include? "enable-msdblib"
      args << "--enable-msdblib"
    end

    if build.include? "enable-sybase-compat"
      args << "--enable-sybase-compat"
    end

    if build.include? "enable-odbc-wide"
      args << "--enable-odbc-wide"
    end

    if build.include? "enable-krb"
      args << "--enable-krb5"
    end

    ENV.universal_binary if build.universal?
    system "./configure", *args
    system 'make'
    ENV.j1 # Or fails to install on multi-core machines
    system 'make install'
  end

  test do
    system "#{bin}/tsql", "-C"
  end
end
