require 'formula'

class Inspircd < Formula
  homepage 'http://www.inspircd.org'
  url 'https://github.com/inspircd/inspircd/archive/v2.0.17.tar.gz'
  sha1 '79c1a2438b926f5cb945db6dd02c4a1416dc9946'

  head 'https://github.com/inspircd/inspircd.git'

  bottle do
    sha1 "e00f0f3742a4868937bd1d609c37c3ab3fc50fd5" => :mavericks
    sha1 "cd9bcce5522b4154fe8793fc505769c9e22e8eed" => :mountain_lion
    sha1 "1fabcc797fe120beefc7f4228d35d7519192c505" => :lion
  end

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
