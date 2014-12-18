class NagiosPlugins < Formula
  homepage "https://www.nagios-plugins.org/"
  url "https://www.nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz"
  sha1 "29b6183ab9d796299dc17c395eef493415d1e9d6"

  bottle do
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
