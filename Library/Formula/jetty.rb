class Jetty < Formula
  homepage "http://www.eclipse.org/jetty/"
  url "http://download.eclipse.org/jetty/9.2.9.v20150224/dist/jetty-distribution-9.2.9.v20150224.tar.gz"
  version "9.2.9.v20150224"
  sha1 "8f8b535841e524ea6f418dc9a8d01b701cd063ea"

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
