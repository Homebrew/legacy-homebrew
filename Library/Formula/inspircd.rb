require 'formula'

class Inspircd < Formula
  homepage 'http://inspircd.github.com'
  url 'https://github.com/inspircd/inspircd/archive/v2.0.10.tar.gz'
  sha1 '9b88b9b58e3e765604c938d1c2ae2c2ab8403d24'

  head 'https://github.com/inspircd/inspircd.git', :branch => 'insp20'

  depends_on 'pkg-config' => :build
  depends_on 'gnutls' => :recommended
  depends_on 'libgcrypt' unless build.without? 'gnutls'
  depends_on 'openssl' => :optional
  depends_on 'pcre' => :optional
  depends_on 'tre' => :optional

  def install
    modules = []
    modules << 'm_ssl_gnutls.cpp' unless build.without? 'gnutls'
    modules << 'm_ssl_openssl.cpp' if build.with? 'openssl'
    modules << 'm_regex_pcre.cpp' if build.with? 'pcre'
    modules << 'm_regex_tre.cpp' if build.with? 'tre'

    system './configure', "--enable-extras=#{modules.join(',')}" unless modules.empty?
    system './configure', "--prefix=#{prefix}", "--with-cc=#{ENV.cc}"
    system 'make install'

    inreplace "#{prefix}/org.inspircd.plist", 'ircdaemon', ENV['USER']
  end
end
