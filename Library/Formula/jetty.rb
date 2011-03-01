require 'formula'

class Jetty <Formula
  url 'http://download.eclipse.org/jetty/stable-7/dist/jetty-distribution-7.3.0.v20110203.tar.gz'
  homepage 'http://www.eclipse.org/jetty/downloads.php'
  md5 '18194e739b7d09f6ae9532fa45a8cf64'

  skip_clean :all

  def install
    rm_rf Dir['bin/*.{cmd,bat,txt}','bin/jetty-cygwin.sh','bin/jetty-xinetd.sh']
    mv 'bin/jetty.sh', 'bin/jetty'
    tmp = File.open('bin/jetty.tmp','w')
    f = File.open('bin/jetty')
    line_num = 1
    f.each do |l|
      if line_num == 2
        tmp << "JETTY_HOME=#{libexec}\n"
      else
        tmp << l
      end
      line_num += 1
    end
    f.close
    tmp.close
    mv 'bin/jetty.tmp', 'bin/jetty'
    chmod 0755, 'bin/jetty'
    libexec.install Dir['*']
    (libexec+'logs').mkpath
    bin.mkpath
    Dir["#{libexec}/bin/*"].each { |f| ln_s f, bin }
  end

end
