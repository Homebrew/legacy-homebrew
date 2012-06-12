require 'formula'

class Freetds < Formula
  homepage 'http://www.freetds.org/'
  url 'http://ibiblio.org/pub/Linux/ALPHA/freetds/stable/freetds-0.91.tar.gz'
  sha1 '3ab06c8e208e82197dc25d09ae353d9f3be7db52'

  depends_on "unixodbc" if ARGV.include? "--with-unixodbc"

  def options
    [['--with-unixodbc', "Compile against unixODBC."]]
  end

  def install
    args = ["--prefix=#{prefix}",
            "--with-tdsver=7.1",
            "--mandir=#{man}"]

    if ARGV.include? "--with-unixodbc"
      args << "--with-unixodbc=#{Formula.factory('unixodbc').prefix}"
    end

    system "./configure", *args
    system 'make'
    ENV.j1 # Or fails to install on multi-core machines
    system 'make install'
  end
end
