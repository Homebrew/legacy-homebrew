class Inspircd < Formula
  homepage "http://www.inspircd.org"
  url "https://github.com/inspircd/inspircd/archive/v2.0.19.tar.gz"
  sha256 "3182fe346257af397fa43952bc7678eb8dafda49da1d286baed5063ffa3f3387"

  head "https://github.com/inspircd/inspircd.git"

  bottle do
    sha256 "9e2be19b91738eea23108c2cd520dca51c3faaa1e0f7d05b32bbf655fade839c" => :yosemite
    sha256 "a532bb1c714631d2da459be1345c4850ef1274daf749a2790604f6e02daf50b3" => :mavericks
    sha256 "7511580f52a56a8c0aef65e8d161817e54befd2762f598c43b67d9fa274138c6" => :mountain_lion
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
