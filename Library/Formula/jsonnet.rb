class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data."
  homepage "https://google.github.io/jsonnet/doc/"
  url "https://github.com/google/jsonnet/archive/v0.8.1.tar.gz"
  sha256 "c844623f3d21d81488b20ba5e32b388d6ffcf68fc6f2216e65c23b7196663382"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c3ed87edc644e760d41f59ca52fa3d04bef21908ba9511ad24eacacac05a4f5" => :el_capitan
    sha256 "0888a627040f4824ce7b68045060d2c8e8dbb779e60c1858dcee9115c67119ee" => :yosemite
    sha256 "f75e9d814e801e60cdfd3eeb5752e6ae861672cc6ab5d14440b1754c01888102" => :mavericks
  end

  needs :cxx11

  depends_on :macos => :mavericks

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
  end

  test do
    require "json"

    (testpath/"example.jsonnet").write <<-EOS
      {
        person1: {
          name: "Alice",
          welcome: "Hello " + self.name + "!",
        },
        person2: self.person1 { name: "Bob" },
      }
    EOS

    expected_output = <<-EOS
      {
        "person1": {
          "name": "Alice",
          "welcome": "Hello Alice!"
        },
        "person2": {
          "name": "Bob",
          "welcome": "Hello Bob!"
        }
      }
    EOS

    output = shell_output("#{bin}/jsonnet #{testpath}/example.jsonnet")
    assert_equal JSON.parse(expected_output), JSON.parse(output)
  end
end
