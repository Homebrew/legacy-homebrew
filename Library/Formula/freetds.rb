require 'formula'

class Freetds < Formula
  url 'http://ibiblio.org/pub/Linux/ALPHA/freetds/stable/freetds-0.91.tar.gz'
  homepage 'http://www.freetds.org/'
  md5 'b14db5823980a32f0643d1a84d3ec3ad'

  depends_on "unixodbc" if ARGV.include? "--with-unixodbc"

  def options
    [['--with-unixodbc', "Compile against unixODBC."]]
  end

  def install
    args = ["--prefix=#{prefix}",
            "--with-tdsver=7.0",
            "--enable-msdblib",
            "--mandir=#{man}"
            ]
    
    if ARGV.include? "--with-unixodbc"
      unixodbc_prefix = Formula.factory('unixodbc').prefix
      args << "--with-unixodbc=#{unixodbc_prefix}"
    end
    
    system "./configure", *args
    system 'make'
    ENV.j1 # Or fails to install on multi-core machines
    system 'make install'
  end
end
