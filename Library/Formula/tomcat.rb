require 'formula'

class Tomcat <Formula
  url 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.6/bin/apache-tomcat-7.0.6.tar.gz'
  homepage 'http://tomcat.apache.org/'
  md5 '1c54578e2e695212ab3ed75170930df4'

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
