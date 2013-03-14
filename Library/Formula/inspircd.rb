require 'formula'

class Inspircd < Formula
  homepage 'http://inspircd.github.com'
  url 'https://github.com/inspircd/inspircd/archive/v2.0.10.tar.gz'
  sha1 '9b88b9b58e3e765604c938d1c2ae2c2ab8403d24'

  head 'https://github.com/inspircd/inspircd.git', :branch => 'insp20'

  skip_clean 'data'
  skip_clean 'logs'

  depends_on 'pkg-config' => :build
  depends_on 'geoip' => :optional
  depends_on 'gnutls' => :optional
  depends_on 'libgcrypt' if build.with? 'gnutls'
  depends_on :mysql => :optional
  depends_on 'pcre' => :optional
  depends_on 'sqlite' => :optional
  depends_on 'tre' => :optional

  option 'without-ldap', 'Build without ldap support'
  option 'without-openssl', 'Build without openssl support'
  option 'without-postgres', 'Build without postgres support'

  def install
    modules = []
    modules << 'm_geoip.cpp' if build.with? 'geoip'
    modules << 'm_ssl_gnutls.cpp' if build.with? 'gnutls'
    modules << 'm_mysql.cpp' if build.with? 'mysql'
    modules << 'm_ssl_openssl.cpp' unless build.without? 'openssl'
    modules << 'm_ldapauth.cpp' unless build.without? 'ldap'
    modules << 'm_ldapoper.cpp' unless build.without? 'ldap'
    modules << 'm_regex_pcre.cpp' if build.with? 'pcre'
    modules << 'm_ssl_pgsql.cpp' unless build.without? 'postgres'
    modules << 'm_sqlite3.cpp' if build.with? 'sqlite'
    modules << 'm_regex_tre.cpp' if build.with? 'tre'

    system './configure', "--enable-extras=#{modules.join(',')}" unless modules.empty?
    system './configure', "--prefix=#{prefix}", "--with-cc=#{ENV.cc}"
    system 'make install'

    inreplace "#{prefix}/org.inspircd.plist", 'ircdaemon', ENV['USER']
  end
end
