require 'formula'

class Pgtap < Formula
  homepage 'http://pgtap.org/'
  url 'http://api.pgxn.org/dist/pgtap/0.94.0/pgtap-0.94.0.zip'
  sha1 '58c04a57d79345c18525ed4aee9db058964408a1'
  head 'https://github.com/theory/pgtap.git'

  depends_on :postgresql

  skip_clean 'share'

  resource 'Test::Harness' do
    url 'http://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.30.tar.gz'
    sha1 '5f7cc2392accaf47100cf2a57c5513c3fa29b1dc'
  end

  resource 'TAP::Parser::SourceHandler::pgTAP' do
    url 'http://cpan.metacpan.org/authors/id/D/DW/DWHEELER/TAP-Parser-SourceHandler-pgTAP-3.29.tar.gz'
    sha1 '8cf6dc2ec833b896a0638390a33e2c477a58e020'
  end

  def install
    resource('Test::Harness').stage do
      system 'perl', 'Makefile.PL', "INSTALL_BASE=#{prefix}", "INSTALLSITEMAN1DIR=#{man1}", "INSTALLSITEMAN3DIR=#{man3}"
      system 'make'
      system 'make', 'install'
    end

    resource('TAP::Parser::SourceHandler::pgTAP').stage do
      system 'perl', 'Build.PL', "--install_base", prefix, '--install_path', "bindoc=#{man1}", '--install_path', "libdoc=#{man3}"
      system './Build'
      system './Build', 'install'
    end

    ENV.prepend_path 'PATH', Formula.factory('postgresql').bin
    system 'which', 'pg_config'
    system 'make'
    system 'make', 'install'
  end

end
