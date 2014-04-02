require "formula"

class Ejabberd < Formula
  homepage "http://www.ejabberd.im"
  url "http://www.process-one.net/downloads/ejabberd/13.12/ejabberd-13.12.tgz"
  sha1 "3aedb5012fab49181961ff24bad3af581f4b30ee"

  bottle do
    sha1 "6483132bdf79af21c0d4e7fc84ec25b4698d0ec7" => :mavericks
    sha1 "55f409c6d9a10a2b1c687050ff80d6247b8db06b" => :mountain_lion
    sha1 "572ed4bc18a5ca6d316e71af3c8b138fc7ffdc8c" => :lion
  end

  depends_on "openssl"
  depends_on "erlang"
  depends_on "libyaml"

  option "32-bit"
  option "with-odbc", "Build with ODBC support"
  option "with-pgsql", "Build with PostgreSQL support"
  option "with-mysql", "Build with MySQL support"

  def install
    ENV["TARGET_DIR"] = ENV["DESTDIR"] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV["MAN_DIR"] = man
    ENV["SBIN_DIR"] = sbin

    if build.build_32_bit?
      %w{ CFLAGS LDFLAGS }.each do |compiler_flag|
        ENV.remove compiler_flag, "-arch #{Hardware::CPU.arch_64_bit}"
        ENV.append compiler_flag, "-arch #{Hardware::CPU.arch_32_bit}"
      end
    end

    args = ["--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--localstatedir=#{var}"]

    args << "--enable-odbc" if build.with? "odbc"
    args << "--enable-pgsql" if build.with? "pgsql"
    args << "--enable-mysql" if build.with? "mysql"

    system "./configure", *args
    system "make"
    system "make", "install"

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
