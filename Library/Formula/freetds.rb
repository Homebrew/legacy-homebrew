require 'formula'

class Freetds < Formula
  homepage 'http://www.freetds.org/'
  url 'http://mirrors.ibiblio.org/freetds/stable/freetds-0.91.tar.gz'
  sha1 '3ab06c8e208e82197dc25d09ae353d9f3be7db52'

  head 'https://git.gitorious.org/freetds/freetds.git'

  depends_on "pkg-config" => :build
  depends_on "unixodbc" => :optional

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  option :universal

  def install
    system "autoreconf -i" if build.head?

    args = %W[--prefix=#{prefix}
              --with-openssl=/usr/bin
              --with-tdsver=7.1
              --mandir=#{man}
            ]

    if build.include? "with-unixodbc"
      args << "--with-unixodbc=#{Formula.factory('unixodbc').prefix}"
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
