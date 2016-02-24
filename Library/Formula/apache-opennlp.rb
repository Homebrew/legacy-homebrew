class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=opennlp/opennlp-1.6.0/apache-opennlp-1.6.0-bin.tar.gz"
  mirror "https://www.us.apache.org/dist/opennlp/opennlp-1.6.0/apache-opennlp-1.6.0-bin.tar.gz"
  sha256 "417ca3d4e535fa69238ab0eb657a0b471da821218d078de959967b31748d99e6"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/opennlp"
  end

  test do
    assert_equal "Hello , friends", pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends").chomp
  end
end
