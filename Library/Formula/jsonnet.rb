class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data."
  homepage "https://google.github.io/jsonnet/doc/"
  url "https://github.com/google/jsonnet/archive/v0.8.5.tar.gz"
  sha256 "514df86f954150baac5cace169bc7df3c6989d61c6d95cf5c0f483a68e84dcac"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2ecd2c543dffa729829c4ac274b63d93f36555ab3fd1cd2f175e24abf56c447" => :el_capitan
    sha256 "a3baed2fa2c5f00aa41274de6824eb12e1f6b8d35f3d7b7a204e4d877e0c5184" => :yosemite
    sha256 "4d60ec983b864e64042d702c80e1e47a64a43272778533715abb28a0fa2fc9e9" => :mavericks
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
