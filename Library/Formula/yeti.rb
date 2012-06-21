require 'formula'

class Yeti < Formula
  homepage 'http://mth.github.com/yeti/'
  url 'https://github.com/mth/yeti/tarball/v0.9.5'
  sha1 '8f92d74609923c462c184ebfe28cb05209e08f1b'

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
