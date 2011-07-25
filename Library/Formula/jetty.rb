require 'formula'

class Jetty < Formula
  url 'http://download.eclipse.org/jetty/stable-7/dist/jetty-distribution-7.4.4.v20110707.zip'
  homepage 'http://jetty.codehaus.org/jetty/index.html'
  md5 '0fcba2ef147f9ee9bd9d64abafd8384e'

  skip_clean :all

  def install
    rm_rf Dir['bin/*.{cmd,bat]}']

    libexec.install Dir['*']
    (libexec+'logs').mkpath

    bin.mkpath
    Dir["#{libexec}/bin/*.sh"].each do |f|
      scriptname = File.basename(f, '.sh')
      (bin+scriptname).write <<-EOS.undent
        #!/bin/bash
        JETTY_HOME=#{libexec}
        #{f} $@
      EOS
      chmod 0755, bin+scriptname
    end
  end
end
