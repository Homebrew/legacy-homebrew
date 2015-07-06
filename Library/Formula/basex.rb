require 'formula'

class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage 'http://basex.org'
  url 'http://files.basex.org/releases/8.2.2/BaseX822.zip'
  version '8.2.2'
  sha256 '6a7a87a95e23a836a35c4f47983dc5d0336eb83e9cf02e1ec48b5c5eb3742003'

  bottle do
    cellar :any
    sha256 "446ecf222327f0a3914cb677b4dccb7bfabeac81451c1ddd989a78375171fd90" => :yosemite
    sha256 "deac3806b1c4e7c7ba2faf448ae2062e5ef073c796791018807a42a48dea81bb" => :mavericks
    sha256 "6a2dd33330cafa32e823c48bad20e763daff81be3b3d7d6721d151c3943184c6" => :mountain_lion
  end

  def install
    rm Dir['bin/*.bat']
    rm_rf "repo"
    rm_rf "data"
    rm_rf "etc"
    prefix.install_metafiles
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "1\n2\n3\n4\n5\n6\n7\n8\n9\n10", shell_output("#{bin}/basex '1 to 10'")
  end
end
