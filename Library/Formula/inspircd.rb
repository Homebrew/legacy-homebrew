class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "http://www.inspircd.org"
  url "https://github.com/inspircd/inspircd/archive/v2.0.20.tar.gz"
  sha256 "5156e2da5da4cfa377705ecd633aee41cdcd785d12627497d55cab5f70dd686f"
  head "https://github.com/inspircd/inspircd.git"

  bottle do
    revision 1
    sha256 "b224270f471897506b1ec091fbe9470392416d0e08ad59aadb2a4ca678c9831f" => :yosemite
    sha256 "56a85222822adba5ce3fb86c8873963b4b5b70435985cc7fc7956afa25d5c78d" => :mavericks
    sha256 "142864c79850cb4a7a1a46e85e5d1ba087de67e938801585e1bd254f21da70d5" => :mountain_lion
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
