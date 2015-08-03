class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=opennlp/opennlp-1.5.3/apache-opennlp-1.5.3-bin.tar.gz"
  mirror "https://www.us.apache.org/dist/opennlp/opennlp-1.5.3/apache-opennlp-1.5.3-bin.tar.gz"
  sha256 "fb6449135dcdd0eef2d1e59c8fe57995c7046b2cb50dd039a48ecda4d3d46fa3"

  def install
    prefix.install_metafiles
    libexec.install Dir["*"]

    bin.write_exec_script libexec/"bin/opennlp"
  end
end
