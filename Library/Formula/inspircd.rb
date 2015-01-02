class Inspircd < Formula
  homepage "http://www.inspircd.org"
  url "https://github.com/inspircd/inspircd/archive/v2.0.18.tar.gz"
  sha1 "40039d9be51ad28493be16b27c9f20bc7fe617a4"

  head "https://github.com/inspircd/inspircd.git"

  bottle do
    sha1 "b1def0c5b281422dbe37e89b2104321b33f685d0" => :yosemite
    sha1 "18db9b5143d5f63677f3dc2fb2eeda09b24334dd" => :mavericks
    sha1 "5cce454e59cf0a0e67e5d4c2bb1d5d94fe8e831d" => :mountain_lion
  end

  skip_clean "data"
  skip_clean "logs"

  depends_on "pkg-config" => :build
  depends_on "geoip" => :optional
  depends_on "gnutls" => :optional
  depends_on :mysql => :optional
  depends_on "openssl" => :optional
  depends_on "pcre" => :optional
  depends_on "postgresql" => :optional
  depends_on "sqlite" => :optional
  depends_on "tre" => :optional

  option "without-ldap", "Build without ldap support"

  def install
    modules = []
    modules << "m_geoip.cpp" if build.with? "geoip"
    modules << "m_ssl_gnutls.cpp" if build.with? "gnutls"
    modules << "m_mysql.cpp" if build.with? "mysql"
    modules << "m_ssl_openssl.cpp" if build.with? "openssl"
    modules << "m_ldapauth.cpp" if build.with? "ldap"
    modules << "m_ldapoper.cpp" if build.with? "ldap"
    modules << "m_regex_pcre.cpp" if build.with? "pcre"
    modules << "m_pgsql.cpp" if build.with? "postgresql"
    modules << "m_sqlite3.cpp" if build.with? "sqlite"
    modules << "m_regex_tre.cpp" if build.with? "tre"

    system "./configure", "--enable-extras=#{modules.join(",")}" unless modules.empty?
    system "./configure", "--prefix=#{prefix}", "--with-cc=#{ENV.cc}"
    system "make", "install"

    inreplace "#{prefix}/org.inspircd.plist", "ircdaemon", ENV["USER"]
  end

  test do
    system "#{bin}/inspircd", "--version"
  end
end
