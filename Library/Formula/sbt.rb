require 'brewkit'

# even though "file -b" reports this as a zip archive, it's just a binary
class HttpDownloadStrategy
  def stage
    FileUtils.mv @dl, File.basename(@url)
  end
end

class Sbt <Formula
  @url='http://simple-build-tool.googlecode.com/files/sbt-launcher-0.5.3.jar'
  @homepage='http://code.google.com/p/simple-build-tool'
  @md5='ff1a0b6da067573b8a06e4b07707b562'

  def install
    sbt_exec = bin+'sbt'
    sbt_exec.write <<-EOS
#!/bin/sh

java -Xmx512M -jar #{prefix}/sbt-launcher-0.5.3.jar "$@"
EOS

    File.chmod(0755, sbt_exec)

    prefix.install Dir['*']
  end
end
