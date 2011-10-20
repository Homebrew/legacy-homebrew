require 'formula'

class SiscScheme < Formula
  url 'http://sourceforge.net/projects/sisc/files/SISC-Lite-zip/1.9.8/sisc-lite-1.9.8.zip'
  md5 'c1b75ecf26af0d733415d36dcdb1d614'
  homepage 'http://sourceforge.net/projects/sisc'

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
