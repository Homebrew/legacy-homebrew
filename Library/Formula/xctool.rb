require 'formula'

class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage 'https://github.com/facebook/xctool'
  url 'https://github.com/facebook/xctool/archive/v0.2.3.tar.gz'
  sha1 'e22b947a4de7bc96feffb6cb24940f61574afbbc'
  head 'https://github.com/facebook/xctool.git'

  bottle do
    cellar :any
    sha1 "5bd00d5d7fa89112bd2de0b49ba36b574d44654b" => :yosemite
    sha1 "f9a420650620b21baf56a6cdc4c0a773049b2e0b" => :mavericks
    sha1 "816fe6d860e1acf6b6fa53057b700a8dcad0de8f" => :mountain_lion
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
