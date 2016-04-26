class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data."
  homepage "https://google.github.io/jsonnet/doc/"
  url "https://github.com/google/jsonnet/archive/v0.8.7.tar.gz"
  sha256 "c1cc21fcc8b6d590bc13af05e5932b07ec0e00c1a9737a01f858a7aefca52ffb"

  bottle do
    cellar :any_skip_relocation
    sha256 "de8636d5e2c72b12302d0b580cc523dd69d42515df6b7e989d3f7d70bf12c626" => :el_capitan
    sha256 "a4f3f40594c54f87347348f1398610f1e7755f1328345572d259bd7d3a0564db" => :yosemite
    sha256 "d873d720f899167b86bb62aa7ef77c148e7daca45d16ecefc9b42e7a5b9185c4" => :mavericks
  end

  needs :cxx11

  depends_on :macos => :mavericks

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
  end

  test do
    require "utils/json"

    (testpath/"example.jsonnet").write <<-EOS
      {
        person1: {
          name: "Alice",
          welcome: "Hello " + self.name + "!",
        },
        person2: self.person1 { name: "Bob" },
      }
    EOS

    expected_output = {
      "person1" => {
        "name" => "Alice",
        "welcome" => "Hello Alice!"
      },
      "person2" => {
        "name" => "Bob",
        "welcome" => "Hello Bob!"
      }
    }

    output = shell_output("#{bin}/jsonnet #{testpath}/example.jsonnet")
    assert_equal expected_output, Utils::JSON.load(output)
  end
end
