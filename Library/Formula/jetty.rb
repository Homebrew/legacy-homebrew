class Jetty < Formula
  homepage "http://www.eclipse.org/jetty/"
  url "http://download.eclipse.org/jetty/9.2.10.v20150310/dist/jetty-distribution-9.2.10.v20150310.tar.gz"
  version "9.2.10.v20150310"
  sha256 "0034587a3dcfdab23fca28291e5e22ae7ff6e80f9f4c7a67f5b2b7777a84b40e"

  def install
    libexec.install Dir['*']
    (libexec+'logs').mkpath

    bin.mkpath
    Dir.glob("#{libexec}/bin/*.sh") do |f|
      scriptname = File.basename(f, '.sh')
      (bin+scriptname).write <<-EOS.undent
        #!/bin/bash
        JETTY_HOME=#{libexec}
        #{f} "$@"
      EOS
      chmod 0755, bin+scriptname
    end
  end
end
