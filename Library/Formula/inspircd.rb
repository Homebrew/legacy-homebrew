class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "http://www.inspircd.org"
  url "https://github.com/inspircd/inspircd/archive/v2.0.21.tar.gz"
  sha256 "bc2f861d754754a108797699319186130ef7d909204eb56ab2c3b1ae80c9d6c5"
  head "https://github.com/inspircd/inspircd.git", :branch => "insp20"

  bottle do
    revision 2
    sha256 "307b4f0942fa473dec8959ecf58b624331b8ff26d0bfc24a557e15bef3e71ab7" => :el_capitan
    sha256 "88d9c2177d00e33929d8ef410a03aa8e4096c781e0c1e2fc18ea6237bcb5bbd7" => :yosemite
    sha256 "3ce1ab0f02026648d603b85aa6dae50205d74eb3c7a698587c2402372eb7aa5f" => :mavericks
  end

  skip_clean "data"
  skip_clean "logs"

  option "without-ldap", "Build without ldap support"

  depends_on "pkg-config" => :build
  depends_on "geoip" => :optional
  depends_on "gnutls" => :optional
  depends_on :mysql => :optional
  depends_on "openssl" => :optional
  depends_on "pcre" => :optional
  depends_on "postgresql" => :optional
  depends_on "sqlite" => :optional
  depends_on "tre" => :optional

  def install
    modules = []
    modules << "m_geoip.cpp" if build.with? "geoip"
    modules << "m_ssl_gnutls.cpp" if build.with? "gnutls"
    modules << "m_mysql.cpp" if build.with? "mysql"
    modules << "m_ssl_openssl.cpp" if build.with? "openssl"
    modules << "m_ldapauth.cpp" << "m_ldapoper.cpp" if build.with? "ldap"
    modules << "m_regex_pcre.cpp" if build.with? "pcre"
    modules << "m_pgsql.cpp" if build.with? "postgresql"
    modules << "m_sqlite3.cpp" if build.with? "sqlite"
    modules << "m_regex_tre.cpp" if build.with? "tre"

    system "./configure", "--enable-extras=#{modules.join(",")}" unless modules.empty?
    system "./configure", "--prefix=#{prefix}", "--with-cc=#{ENV.cc}"
    system "make", "install"
  end

  def post_install
    inreplace "#{prefix}/org.inspircd.plist", "ircdaemon", ENV["USER"]
  end

  test do
    system "#{bin}/inspircd", "--version"
  end
end
