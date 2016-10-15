class Jp < Formula
  desc "Command-line interface to JMESPath, a query language for JSON"
  homepage "http://jmespath.org/"
  url "https://github.com/jmespath/jp/archive/0.0.4.tar.gz"
  sha256 "374df14aed82776876d38fa5370c126468d147b9ec00861eca5ea16955007476"

  depends_on "go" => :build

  def install
    system "scripts/build-self-contained.sh"
    bin.install "jp"
  end

  test do
    assert_equal "bar\n", pipe_output("#{bin}/jp -u foo", '{"foo": "bar"}')
  end
end
