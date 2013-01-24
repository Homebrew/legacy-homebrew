require 'formula'

class Inspircd < Formula
  homepage 'http://inspircd.github.com'
  url 'https://github.com/inspircd/inspircd/archive/v2.0.10.tar.gz'
  sha1 '9b88b9b58e3e765604c938d1c2ae2c2ab8403d24'

  head 'https://github.com/inspircd/inspircd.git', :branch => 'insp20'

  option 'without-gnutls', 'Disable the GnuTLS module'
  option 'with-openssl', 'Enable the OpenSSL module'
  option 'with-pcre', 'Enable the PCRE module'
  option 'with-tre', 'Enable the TRE module'

  depends_on 'pkg-config' => :build
  depends_on 'gnutls' => :recommended unless build.include? 'without-gnutls'
  depends_on 'libgcrypt' unless build.include? 'without-gnutls'
  depends_on 'openssl' if build.include? 'with-openssl'
  depends_on 'pcre' if build.include? 'with-pcre'
  depends_on 'tre' if build.include? 'with-tre'

  def install
    modules = []
    modules << 'm_ssl_gnutls.cpp' unless build.include? 'without-gnutls'
    modules << 'm_ssl_openssl.cpp' if build.include? 'with-openssl'
    modules << 'm_regex_pcre.cpp' if build.include? 'with-pcre'
    modules << 'm_regex_tre.cpp' if build.include? 'with-tre'

    system './configure', "--enable-extras=#{modules.join(',')}" unless modules.empty?
    system './configure', "--prefix=#{prefix}", "--with-cc=#{ENV.cc}"
    system 'make install'

    inreplace "#{prefix}/org.inspircd.plist", 'ircdaemon', ENV['USER']
  end
end
