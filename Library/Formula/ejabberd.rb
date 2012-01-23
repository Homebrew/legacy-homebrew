require 'formula'

class Ejabberd < Formula
  url "http://www.process-one.net/downloads/ejabberd/2.1.9/ejabberd-2.1.9.tar.gz"
  homepage 'http://www.ejabberd.im'
  md5 '29ca14ea62f90736322e4e6720331352'

  depends_on "openssl" if MacOS.leopard?
  depends_on "erlang"

  def options
    [['--odbc', "Build with ODBC support."]]
  end

  def install
    ENV['TARGET_DIR'] = ENV['DESTDIR'] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV['MAN_DIR'] = man
    ENV['SBIN_DIR'] = sbin

    Dir.chdir "src" do
      args = ["--prefix=#{prefix}",
              "--sysconfdir=#{etc}",
              "--localstatedir=#{var}"]

      if MacOS.leopard?
        openssl = Formula.factory('openssl')
        args << "--with-openssl=#{openssl.prefix}"
      end

      args << "--enable-odbc" if ARGV.include? '--odbc'

      system "./configure", *args
      system "make"
      system "make install"
    end

    (etc+"ejabberd").mkpath
    (var+"lib/ejabberd").mkpath
    (var+"spool/ejabberd").mkpath
  end

  def caveats; <<-EOS.undent
    If you face nodedown problems, concat your machine name to:
      /private/etc/hosts
    after 'localhost'.
    EOS
  end
end
