class Jsonpp < Formula
  desc "Command-line JSON pretty-printer"
  homepage "https://jmhodges.github.io/jsonpp/"
  url "https://github.com/jmhodges/jsonpp/releases/v1.2.0/715/jsonpp-1.2.0-osx-x86_64.tar.gz"
  version "1.2.0"
  sha256 "f680a18341fec15d0e4235e579e551ffab243e0ea9e6f5fc90106a62db8f5780"

  def install
    bin.install "jsonpp"
  end

  test do
    expected = <<-EOS.undent.chomp
      {
        "foo": "bar",
        "baz": "qux"
      }
    EOS
    assert_equal expected, pipe_output(bin/"jsonpp", '{"foo":"bar","baz":"qux"}')
  end
end
