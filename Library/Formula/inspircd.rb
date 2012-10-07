require 'formula'

class Inspircd < Formula
  homepage 'http://inspircd.github.com'
  url 'https://github.com/downloads/inspircd/inspircd/InspIRCd-2.0.9.tar.bz2'
  sha1 'a1b377a9c9916dced716c34c669060d4590fbb0c'

  head 'https://github.com/inspircd/inspircd.git', :branch => 'insp20'

  option 'without-gnutls', 'Disable the GnuTLS module'
  option 'with-openssl', 'Enable the OpenSSL module'
  option 'with-pcre', 'Enable the PCRE module'
  option 'with-tre', 'Enable the TRE module'

  depends_on 'pkg-config' => :build
  depends_on 'gnutls' unless build.include? 'without-gnutls'
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
