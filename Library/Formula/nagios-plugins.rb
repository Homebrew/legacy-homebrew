class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://www.nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz"
  sha256 "8f0021442dce0138f0285ca22960b870662e28ae8973d49d439463588aada04a"

  bottle do
    sha256 "df7f1e32499d1ec5f2d9f790109cce9d6e4a1e8b6a495a531fc8d9d1609c5bb7" => :el_capitan
    sha256 "6eee15fa36584d0bf1973144ca38ba22a9607a89845b33355bd7a164412e9e90" => :yosemite
    sha256 "a0b386cfcfb80d39aa71f151f221e8ef912169354f2c00db8b6c086b64dca1fe" => :mavericks
    sha256 "e03df47ea1bebec1cc1941b563441b5b3f651b15de8a6c99081fc131266a1490" => :mountain_lion
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
