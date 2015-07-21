class Jsonschema2pojo < Formula
  desc "Generates Java types from JSON Schema (or example JSON) and annotates those types for data-binding with Jackson 1.x or 2.x, Gson, etc"
  homepage "http://www.jsonschema2pojo.org/"
  url "https://github.com/joelittlejohn/jsonschema2pojo/releases/download/jsonschema2pojo-0.4.13/jsonschema2pojo-0.4.13.tar.gz"
  sha256 "b7002d929645dbadd6367ff2ac8a69bb0978538d4ad4f46a195d645b5d341d21"

  depends_on :java => "1.6+"

  def install
    libexec.install %w[jsonschema2pojo-cli-0.4.13.jar lib]
    bin.write_jar_script libexec/"jsonschema2pojo-cli-0.4.13.jar", "jsonschema2pojo"
  end

  test do
    system "jsonschema2pojo"
  end
end
