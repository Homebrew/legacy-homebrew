require 'formula'

class Saxon < Formula
  version '3.0.1'
  url 'http://downloads.sourceforge.net/saxon/saxonhe9-3-0-1j.zip'
  homepage 'http://saxon.sourceforge.net/'
  md5 '1783d5aff6ddae1b56f04a4005371ea6'


  def install
    prefix.install "saxon9he.jar"
    #Add an executable shell-script
    (bin + "saxon").write "#!/bin/sh\njava -jar #{prefix}/saxon9he.jar $*"
  end
end
