require 'brewkit'

# even though "file -b" reports this as a zip archive, it's just a binary
class SbtHttpDownloadStrategy <CurlDownloadStrategy
  def stage
    FileUtils.mv @dl, File.basename(@url)
  end
end

class Sbt <Formula
  JAR = 'sbt-launcher-0.5.5.jar'
  url "http://simple-build-tool.googlecode.com/files/#{JAR}"
  homepage 'http://code.google.com/p/simple-build-tool'
  md5 'e3593448b3be17ce1666c6241b8d2f90'

  def download_strategy
    SbtHttpDownloadStrategy
  end

  def install
    (bin+'sbt').write <<-EOS
#!/bin/sh

java -Xmx512M -jar #{prefix}/#{JAR} "$@"
EOS

    prefix.install Dir['*']
  end
end
