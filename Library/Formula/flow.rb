require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.7.0.tar.gz"
  sha1 "654b6bce4f9c8af438bb0f99b7dcdc71e82dba7a"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha256 "34b42899cefa875566ba8ffdc49b30a23e564169574a661b26f10110153bcd3a" => :yosemite
    sha256 "63ecd238a259c6b722d8dee6ff068d6fe371dc92b06bccc530d6301737f7aa78" => :mavericks
    sha256 "147169d0dd8a16718b6f7273753107ba34a5deb99c2abaac25e5ba334b49131b" => :mountain_lion
  end

  depends_on "objective-caml" => :build

  def install
    system "make"
    bin.install "bin/flow"
    (share/"flow").install "bin/examples"
  end

  test do
    output = `#{bin}/flow single #{share}/flow/examples/01_HelloWorld`
    assert_match(/This type is incompatible with/, output)
    assert_match(/Found 1 error/, output)
  end
end
