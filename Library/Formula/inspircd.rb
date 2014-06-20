require 'formula'

class Inspircd < Formula
  homepage 'http://www.inspircd.org'
  url 'https://github.com/inspircd/inspircd/archive/v2.0.16.tar.gz'
  sha1 '5ea8e81124dc933ba289a4eb5782a66874e5d7e4'
  revision 1

  head 'https://github.com/inspircd/inspircd.git'

  skip_clean 'data'
  skip_clean 'logs'

  depends_on 'pkg-config' => :build
  depends_on 'geoip' => :optional
  depends_on 'gnutls' => :optional
  depends_on 'libgcrypt' if build.with? 'gnutls'
  depends_on :mysql => :optional
  depends_on 'pcre' => :optional
  depends_on 'postgresql' => :optional
  depends_on 'sqlite' => :optional
  depends_on 'tre' => :optional

  option 'without-ldap', 'Build without ldap support'
  option 'without-openssl', 'Build without openssl support'

  # Fix for runtime linker errors when loading modules compiled with LLVM 3.4
  patch :p1 do
    url 'https://github.com/inspircd/inspircd/commit/b65fb065b5a77aeea056f88e1b8d96ec8fbea47c.diff'
    sha1 '13005aa29dd6ee37a30aca805d99789220884c9c'
  end

  def install
    modules = []
    modules << 'm_geoip.cpp' if build.with? 'geoip'
    modules << 'm_ssl_gnutls.cpp' if build.with? 'gnutls'
    modules << 'm_mysql.cpp' if build.with? 'mysql'
    modules << 'm_ssl_openssl.cpp' if build.with? 'openssl'
    modules << 'm_ldapauth.cpp' if build.with? 'ldap'
    modules << 'm_ldapoper.cpp' if build.with? 'ldap'
    modules << 'm_regex_pcre.cpp' if build.with? 'pcre'
    modules << 'm_pgsql.cpp' if build.with? 'postgresql'
    modules << 'm_sqlite3.cpp' if build.with? 'sqlite'
    modules << 'm_regex_tre.cpp' if build.with? 'tre'

    system './configure', "--enable-extras=#{modules.join(',')}" unless modules.empty?
    system './configure', "--prefix=#{prefix}", "--with-cc=#{ENV.cc}"
    system 'make install'

    inreplace "#{prefix}/org.inspircd.plist", 'ircdaemon', ENV['USER']
  end
end
