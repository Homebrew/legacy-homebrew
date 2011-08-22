require 'formula'

class Jetty < Formula
  url 'http://download.eclipse.org/jetty/stable-7/dist/jetty-distribution-7.4.5.v20110725.zip'
  homepage 'http://jetty.codehaus.org/jetty/index.html'
  md5 'dd9cfb412bf9be779a6db81be0933789'
  version '7.4.5'

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