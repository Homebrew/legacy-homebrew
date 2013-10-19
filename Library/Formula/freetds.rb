require 'formula'

class Freetds < Formula
  homepage 'http://www.freetds.org/'
  url 'http://mirrors.ibiblio.org/freetds/stable/freetds-0.91.tar.gz'
  sha1 '3ab06c8e208e82197dc25d09ae353d9f3be7db52'

  head do
    url 'https://git.gitorious.org/freetds/freetds.git'

    depends_on :automake
    depends_on :libtool
  end

  option :universal
  option "enable-msdblib", "Enable Microsoft behavior in the DB-Library API where it diverges from Sybase's"
  option "enable-sybase-compat", "Enable close compatibility with Sybase's ABI, at the expense of other features"

  depends_on "pkg-config" => :build
  depends_on "unixodbc" => :optional

  def install
    system "autoreconf -i" if build.head?

    args = %W[--prefix=#{prefix}
              --with-openssl=#{MacOS.sdk_path}/usr
              --with-tdsver=7.1
              --mandir=#{man}
            ]

    if build.include? "with-unixodbc"
      args << "--with-unixodbc=#{Formula.factory('unixodbc').prefix}"
    end

    if build.include? "enable-msdblib"
      args << "--enable-msdblib"
    end

    if build.include? "enable-sybase-compat"
      args << "--enable-sybase-compat"
    end

    ENV.universal_binary if build.universal?
    system "./configure", *args
    system 'make'
    ENV.j1 # Or fails to install on multi-core machines
    system 'make install'
  end

  def test
    system "#{bin}/tsql", "-C"
  end
end
