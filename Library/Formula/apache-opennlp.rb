require "formula"

class ApacheOpennlp < Formula
  homepage "http://opennlp.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=opennlp/opennlp-1.5.3/apache-opennlp-1.5.3-bin.tar.gz"
  mirror "http://www.us.apache.org/dist/opennlp/opennlp-1.5.3/apache-opennlp-1.5.3-bin.tar.gz"
  sha1 "e14b41a4f1f1ae7fd12713bbdd8452b367bfdc9e"

  def install
    prefix.install_metafiles
    libexec.install Dir['*']

    bin.write_exec_script libexec/'bin/opennlp'
  end
end
