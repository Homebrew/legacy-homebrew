class Jsonnet < Formula
  desc "Jsonnet is a domain specific configuration language that helps you define JSON data."
  homepage "https://google.github.io/jsonnet/doc/"
  url "https://github.com/google/jsonnet/archive/v0.7.9.tar.gz"
  sha256 "103a262636b8db3bfc7dcef7a5d93912d6bf713dd468e188760f6622a9889e44"

  def install
    system "make"
    bin.install "jsonnet"
  end

  test do
    require 'json'

    (testpath/"example.jsonnet").write <<-PAYLOAD
      {
        person1: {
          name: "Alice",
          welcome: "Hello " + self.name + "!",
        },
        person2: self.person1 { name: "Bob" },
      }
    PAYLOAD

    expected_output = <<-PAYLOAD
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
    PAYLOAD

    output = `"#{bin}/jsonnet" #{testpath}/example.jsonnet`

    assert_equal JSON.parse(expected_output), JSON.parse(output)
  end
end
