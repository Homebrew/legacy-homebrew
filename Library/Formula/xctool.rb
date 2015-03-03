require 'formula'

class Xctool < Formula
  homepage 'https://github.com/facebook/xctool'
  url 'https://github.com/facebook/xctool/archive/v0.2.3.tar.gz'
  sha1 'e22b947a4de7bc96feffb6cb24940f61574afbbc'
  head 'https://github.com/facebook/xctool.git'

  bottle do
    cellar :any
    sha1 "71034d5372fa3cee7bde82febf2be7dd3d56ec45" => :yosemite
    sha1 "5a842c2aac6d6e04ab8d51061fd7052011b6a6b8" => :mavericks
    sha1 "384f13a1e0750e1c16cf112eb97c1f44bb724cd2" => :mountain_lion
  end

  depends_on :xcode => "5.0"

  def install
    system "./scripts/build.sh", "XT_INSTALL_ROOT=#{libexec}"
    bin.install_symlink "#{libexec}/bin/xctool"
  end

  test do
    system "(#{bin}/xctool -help; true)"
  end
end
