require 'formula'

class Ejabberd < Formula
  homepage 'http://www.ejabberd.im'
  url "http://www.process-one.net/downloads/ejabberd/2.1.11/ejabberd-2.1.11.tgz"
  md5 'a70b040c4e7602f47718c8afe8780d50'

  depends_on "openssl" if MacOS.leopard?
  depends_on "erlang"

  option "32-bit"
  option 'with-odbc', "Build with ODBC support"

  def install
    ENV['TARGET_DIR'] = ENV['DESTDIR'] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV['MAN_DIR'] = man
    ENV['SBIN_DIR'] = sbin

    if build.build_32_bit?
      %w{ CFLAGS LDFLAGS }.each do |compiler_flag|
        ENV.remove compiler_flag, "-arch x86_64"
        ENV.append compiler_flag, "-arch i386"
      end
    end

    cd "src" do
      args = ["--prefix=#{prefix}",
              "--sysconfdir=#{etc}",
              "--localstatedir=#{var}"]

      if MacOS.leopard?
        openssl = Formula.factory('openssl')
        args << "--with-openssl=#{openssl.prefix}"
      end

      args << "--enable-odbc" if build.include? 'with-odbc'

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
