class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "http://www.inspircd.org"
  url "https://github.com/inspircd/inspircd/archive/v2.0.21.tar.gz"
  sha256 "bc2f861d754754a108797699319186130ef7d909204eb56ab2c3b1ae80c9d6c5"
  head "https://github.com/inspircd/inspircd.git", :branch => "insp20"

  bottle do
    sha256 "ca450ea591b9e69aa0d2632225eabd9cf88cbd212d91beb49da38ccb80cc6bf0" => :el_capitan
    sha256 "20f8be014a3d417d5ef68c896862c9670825b41c670a36e9684d10ac6f84f294" => :yosemite
    sha256 "7a6ce74d3bdbe759fc229e84bdfe5fde5680252c195ac9417ba837d3b4785780" => :mavericks
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
