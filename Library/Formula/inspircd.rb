class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "http://www.inspircd.org"
  url "https://github.com/inspircd/inspircd/archive/v2.0.20.tar.gz"
  sha256 "5156e2da5da4cfa377705ecd633aee41cdcd785d12627497d55cab5f70dd686f"

  head "https://github.com/inspircd/inspircd.git"

  bottle do
    sha256 "fec94f81b70029ca744f6560236606cdaea923cad8f1a04568891a1d9f07a785" => :yosemite
    sha256 "8f517ee50663da8638c58b729634f57bd8486c841f4027a61910ce3b80276f41" => :mavericks
    sha256 "250eba4355daa9ffe60aba0892f78ff6092f16d00a13afa6aab59a9402ef6eff" => :mountain_lion
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
