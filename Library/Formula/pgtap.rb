require 'formula'

class Pgtap < Formula
  homepage 'http://pgtap.org/'
  url 'http://api.pgxn.org/dist/pgtap/0.94.0/pgtap-0.94.0.zip'
  sha1 '58c04a57d79345c18525ed4aee9db058964408a1'
  head 'https://github.com/theory/pgtap.git'

  depends_on :postgresql
  depends_on 'cpanminus'

  skip_clean 'share'

  def install
    pg_prove
    ENV.prepend_path 'PATH', Formula.factory('postgresql').bin
    system "make install"
  end

  def pg_prove
    arch  = %x(perl -MConfig -E 'print $Config{archname}')
    plib  = "#{HOMEBREW_PREFIX}/lib/perl5"
    ENV['PERL5LIB'] = "#{plib}:#{plib}/#{arch}:#{lib}:#{lib}/#{arch}"
    ENV.remove_from_cflags(/-march=\w+/)
    ENV.remove_from_cflags(/-msse\d?/)

    # Install TAP::Parser::SourceHandler::pgTAP.
    system "cpanm --local-lib '#{prefix}' --notest TAP::Parser::SourceHandler::pgTAP"

    # Remove perllocal.pod, since it just gets in the way of other modules.
    rm "#{prefix}/lib/perl5/#{arch}/perllocal.pod", :force => true
  end

end
