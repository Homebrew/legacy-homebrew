class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data."
  homepage "https://google.github.io/jsonnet/doc/"
  url "https://github.com/google/jsonnet/archive/v0.8.2.tar.gz"
  sha256 "590d7f307c10b4c921481f15d54edd0087f4f682e7ad6ca5e0fd950e2c53228b"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2823a4299703206ce57b1747c2a160e30e6649cd970016e67d5551f1e03ea80" => :el_capitan
    sha256 "de326760e6422be1061051075aa3a72d5b6da3b0cc2fc567a476a12cf8ec3c7c" => :yosemite
    sha256 "744eac66b95d09a07c4797bf61cb1e51959f1165b1973a76063b5a6d9adec109" => :mavericks
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
