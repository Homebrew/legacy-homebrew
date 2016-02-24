class Jsonschema2pojo < Formula
  desc "Generates Java types from JSON Schema (or example JSON)"
  homepage "http://www.jsonschema2pojo.org/"
  url "https://github.com/joelittlejohn/jsonschema2pojo/releases/download/jsonschema2pojo-0.4.13/jsonschema2pojo-0.4.13.tar.gz"
  sha256 "b7002d929645dbadd6367ff2ac8a69bb0978538d4ad4f46a195d645b5d341d21"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    libexec.install %w[jsonschema2pojo-cli-0.4.13.jar lib]
    bin.write_jar_script libexec/"jsonschema2pojo-cli-0.4.13.jar", "jsonschema2pojo"
  end

  test do
    json = <<-EOS.undent.chomp
    {
      "type":"object",
      "properties": {
        "foo": {
          "type": "string"
        },
        "bar": {
          "type": "integer"
        },
        "baz": {
          "type": "boolean"
        }
      }
    }
    EOS

    (testpath/"src/jsonschema.json").write json
    system "#{bin}/jsonschema2pojo", "-s", testpath/"src", "-t", testpath/"out"
    assert (testpath/"out/Jsonschema.java").exist?
  end
end
