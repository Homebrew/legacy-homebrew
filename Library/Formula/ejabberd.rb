require "formula"

class Ejabberd < Formula
  homepage "http://www.ejabberd.im"
  url "https://www.process-one.net/downloads/ejabberd/14.05/ejabberd-14.05.tgz"
  sha1 "bad6b91ca6b9ac30ffe8b2eb0c5bb759d7742fab"

  bottle do
    sha1 "0951237f1710e8c3de1c8c68501f53532036d726" => :mavericks
    sha1 "7f1ffe76d100b3a2d00d1578e38db8f5f944859a" => :mountain_lion
    sha1 "582da64c98ce8be147cfd17f2d464e5806d849e3" => :lion
  end

  option "brewed-zlib", "Use Homebrew's zlib for stream compression"
  option "brewed-libiconv", "Use Homebrew's iconv for IRC transport."
  option "32-bit"

  depends_on "openssl"
  depends_on "erlang"
  depends_on "libyaml"
  depends_on "expat"
  depends_on "unixodbc" => :optional
  depends_on "postgresql" => :optional
  depends_on "mysql" => :optional
  depends_on "zlib" if build.with? "brewed-zlib"
  depends_on "libiconv" if build.with? "brewed-libiconv"
  # for CAPTCHA challenges
  depends_on "imagemagick" => :optional

  def install
    ENV["TARGET_DIR"] = ENV["DESTDIR"] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV["MAN_DIR"] = man
    ENV["SBIN_DIR"] = sbin

    # Homebrew's ENV cc fails to build
    ENV["CC"] = "/usr/bin/clang"

    if build.build_32_bit?
      %w{ CFLAGS LDFLAGS }.each do |compiler_flag|
        ENV.remove compiler_flag, "-arch #{Hardware::CPU.arch_64_bit}"
        ENV.append compiler_flag, "-arch #{Hardware::CPU.arch_32_bit}"
      end
    end

    args = ["--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--localstatedir=#{var}"]

    args << "--enable-odbc" if build.with? "unixodbc"
    args << "--enable-pgsql" if build.with? "postgresql"
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
