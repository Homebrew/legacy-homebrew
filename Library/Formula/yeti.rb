require 'formula'

class Yeti < Formula
  homepage 'http://mth.github.io/yeti/'
  url 'https://github.com/mth/yeti/archive/v0.9.8.tar.gz'
  sha1 '64e6174f765fd1444eff70c4a96ae76b2daa6c79'

  head 'https://github.com/mth/yeti.git'

  def install
    system "ant jar"

    prefix.install "yeti.jar"
    (bin+'yeti').write <<-EOS.undent
      #!/bin/sh
      YETI=#{prefix}/yeti.jar
      java -server -jar "$YETI" "$@"
      EOS
  end
end
