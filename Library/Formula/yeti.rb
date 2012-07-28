require 'formula'

class Yeti < Formula
  homepage 'http://mth.github.com/yeti/'
  url 'https://github.com/mth/yeti/tarball/v0.9.6'
  sha1 'f10d17d9235740cee1f7c37711d9979f84a9e078'

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
