require 'formula'

class Tomcat <Formula
  url 'http://www.fightrice.com/mirrors/apache/tomcat/tomcat-6/v6.0.26/bin/apache-tomcat-6.0.26.tar.gz'
  homepage 'http://tomcat.apache.org/'
  md5 'f9eafa9bfd620324d1270ae8f09a8c89'

  skip_clean :all

  def install
    rm_rf Dir['bin/*.{cmd,bat]}']
    libexec.install Dir['*']
    (libexec+'logs').mkpath
    bin.mkpath
    Dir["#{libexec}/bin/*.sh"].each { |f| ln_s f, bin }
  end

  def caveats; <<-EOS.undent
    Note: Some of the support scripts used by Tomcat have very generic names.
    These are likely to conflict with support scripts used by other Java-based
    server software.

    You may want to `brew unlink tomcat` and add:
      #{bin}
    to your PATH instead.
    EOS
  end
end
