class Jetty < Formula
  homepage "http://www.eclipse.org/jetty/"
  url "http://download.eclipse.org/jetty/9.2.8.v20150217/dist/jetty-distribution-9.2.8.v20150217.tar.gz"
  version "9.2.8.v20150217"
  sha1 "d565cb0abe9c265f573a16c5dfd9ae36e769c908"

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
