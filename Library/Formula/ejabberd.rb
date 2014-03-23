require 'formula'

class Ejabberd < Formula
  homepage 'http://www.ejabberd.im'
  url "http://www.process-one.net/downloads/ejabberd/13.12/ejabberd-13.12.tgz"
  sha1 '3aedb5012fab49181961ff24bad3af581f4b30ee'

  option "32-bit"
  option 'with-odbc', "Build with ODBC support"
  option 'with-pgsql', "Build with PostgreSQL support"
  option 'with-mysql', "Build with MySQL support"
  option 'with-brewed-openssl', "Build with Homebrew OpenSSL instead of the system version"

  depends_on "openssl" if MacOS.version <= :leopard or build.with? "brewed-openssl"
  depends_on "erlang"
  depends_on "libyaml"
  
  def install
    ENV['TARGET_DIR'] = ENV['DESTDIR'] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV['MAN_DIR'] = man
    ENV['SBIN_DIR'] = sbin

    if build.build_32_bit?
      %w{ CFLAGS LDFLAGS }.each do |compiler_flag|
        ENV.remove compiler_flag, "-arch #{Hardware::CPU.arch_64_bit}"
        ENV.append compiler_flag, "-arch #{Hardware::CPU.arch_32_bit}"
      end
    end

    args = ["--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--localstatedir=#{var}"]

    if MacOS.version <= :leopard or build.with? "brewed-openssl"
      ENV.prepend "LDFLAGS", "-L#{Formula["openssl"].opt_prefix}/lib"
      ENV.prepend "CPPFLAGS", "-I#{Formula["openssl"].opt_prefix}/include"
    end

    args << "--enable-odbc" if build.with? "odbc"
    args << "--enable-pgsql" if build.with? "pgsql"
    args << "--enable-mysql" if build.with? "mysql"

    system "./configure", *args
    system "make"
    system "make install"


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
