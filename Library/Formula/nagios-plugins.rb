class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://www.nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz"
  sha256 "8f0021442dce0138f0285ca22960b870662e28ae8973d49d439463588aada04a"

  bottle do
    sha256 "df7f1e32499d1ec5f2d9f790109cce9d6e4a1e8b6a495a531fc8d9d1609c5bb7" => :el_capitan
    sha1 "85ad17ccfbd5f5e89395608155a212f25f67f22f" => :yosemite
    sha1 "4eabfc3289ab822260636560941c4e02bd4185ca" => :mavericks
    sha1 "e4d99ed31bfbe4e721434bba41fc0f869e8b4314" => :mountain_lion
  end

  depends_on "openssl"
  depends_on "postgresql" => :optional
  depends_on :mysql => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl"].opt_prefix}
    ]

    args << "--with-pgsql=#{Formula["postgresql"].opt_prefix}" if build.with? "postgresql"

    system "./configure", *args
    system "make", "install"
    system "make", "install-root" # Do we still want to support root-install Jack?
    sbin.write_exec_script Dir["#{libexec}/sbin/*"]
  end

  def caveats
    <<-EOS.undent
    All plugins have been installed in:
      #{HOMEBREW_PREFIX}/sbin
    EOS
  end
end
