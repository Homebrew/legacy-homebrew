require 'formula'

class SiscScheme < Formula
  homepage 'http://sourceforge.net/projects/sisc'
  url 'http://sourceforge.net/projects/sisc/files/SISC%20Lite/1.16.6/sisc-lite-1.16.6.tar.gz'
  sha1 '4572dc584f2a8e82e1a47c49ea5b9d8cf151775d'

  def script; <<-EOS.undent
    #!/bin/sh
    SISC_HOME=#{prefix}
    EOS
  end

  def install
    file = File.open("sisc", "rb")
    contents = file.read
    run_script = script
    run_script += contents
    prefix.install Dir['*']
    (bin+'sisc').write run_script
  end
end
