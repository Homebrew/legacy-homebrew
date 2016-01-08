class GenerateJsonSchema < Formula
  desc "Generate a JSON Schema from Sample JSON"
  homepage "https://github.com/Nijikokun/generate-schema"
  url "https://github.com/Nijikokun/generate-schema/archive/v2.1.1.tar.gz"
  sha256 "bf43a7e616419876293e7de738dece27b3deb719cf5e8cc99bb309a5fb179af0"

  head "https://github.com/Nijikokun/generate-schema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "04ed1478348610996f3def3a546d6a99b844100bb85f9b74d246f85f2f424b4c" => :el_capitan
    sha256 "54ddac9d0e01ef646f541ecbd5c8adfd734aec0f2e623ed97b504c79fa228fea" => :yosemite
    sha256 "de5e23cd917d04cdd74642c905b67a65515b846138e48bb34e7a6b7eb8774a79" => :mavericks
  end

  depends_on "node"

  def install
    ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"

    system "npm", "install"
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    require "open3"

    input = <<-EOS.undent
      {
          "id": 2,
          "name": "An ice sculpture",
          "price": 12.50,
          "tags": ["cold", "ice"],
          "dimensions": {
              "length": 7.0,
              "width": 12.0,
              "height": 9.5
          },
          "warehouseLocation": {
              "latitude": -78.75,
              "longitude": 20.4
          }
      }
    EOS

    output = <<-EOS.undent.chomp
      Welcome to Generate Schema 2.1.1

        Mode: json

      * Example Usage:
        > {a:'b'}
        { a: { type: 'string' } }

      To quit type: exit

      > {
        "$schema": "http://json-schema.org/draft-04/schema#",
        "type": "object",
        "properties": {
          "id": {
            "type": "number"
          },
          "name": {
            "type": "string"
          },
          "price": {
            "type": "number"
          },
          "tags": {
            "type": "array",
            "items": {
              "type": "string"
            }
          },
          "dimensions": {
            "type": "object",
            "properties": {
              "length": {
                "type": "number"
              },
              "width": {
                "type": "number"
              },
              "height": {
                "type": "number"
              }
            }
          },
          "warehouseLocation": {
            "type": "object",
            "properties": {
              "latitude": {
                "type": "number"
              },
              "longitude": {
                "type": "number"
              }
            }
          }
        }
      }
      >
    EOS

    # As of v2.1.1, there is a bug when passing in a filename as an argument
    # The following commented out test will fail until this bug is fixed.
    # ("#{testpath}/test.json").write(input)
    # system "#{bin}/generate-schema", "#{testpath}/test.json"

    # Until it is fixed, STDIN can be used as a workaround
    Open3.popen3("#{bin}/generate-schema") do |stdin, stdout, _|
      stdin.write(input)
      stdin.close
      # Program leaks spaces at the end of lines. This line cleans them up
      # so they don't cause the assert below to erroneously fail.
      result = stdout.map(&:rstrip).join("\n")
      assert_equal output, result
    end
  end
end
