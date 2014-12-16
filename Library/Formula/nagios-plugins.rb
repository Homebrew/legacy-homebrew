require "formula"

class NagiosPlugins < Formula
  homepage "https://www.nagios-plugins.org/"
  url "https://www.nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz"
  sha1 "29b6183ab9d796299dc17c395eef493415d1e9d6"

  bottle do
    sha1 "78fbc5df2f4426e7fc435ea9d597d14180d9e950" => :yosemite
    sha1 "52560d1d02b9710df9c4a2315d8357ee6d7bfda4" => :mavericks
    sha1 "0f3bb80908ff0cdfaae651c2100b48a048d69257" => :mountain_lion
  end

  depends_on "openssl" => :optional
  depends_on "gnutls" => :optional
  depends_on "postgresql" => :optional
  depends_on :mysql => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --libexecdir=#{libexec}/sbin
    ]

    args << "--with-pgsql=#{Formula["postgresql"].opt_prefix}" if build.with? "postgresql"

    if build.with? "gnutls"
      args << "--with-gnutls=#{Formula["gnutls"].opt_prefix}"
    else
      args << "--with-openssl=#{Formula["openssl"].opt_prefix}"
    end

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

  test do
    system "#{sbin}/check_ntp_time", "-H", "pool.ntp.org"
  end
end
