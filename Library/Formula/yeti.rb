require 'formula'

class Yeti < Formula
  homepage 'http://mth.github.com/yeti/'
  url 'https://github.com/mth/yeti/archive/v0.9.7.tar.gz'
  sha1 'ae1f86f7e18ee05cb6f9a9f1320d7f833d0bdd56'

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
