require 'formula'

class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage 'https://github.com/facebook/xctool'
  url 'https://github.com/facebook/xctool/archive/v0.2.4.tar.gz'
  sha256 '0eb7a0ed45feb413ee12fd10f2425975124c1ee3c5dd55e35fa1ff271cea841a'
  head 'https://github.com/facebook/xctool.git'

  bottle do
    cellar :any
    sha256 "4ec86b7dcd1cfe3b60064d037f58fe79a31e1747b277f04c1c8dc7880e573597" => :yosemite
    sha256 "6d59a5ba2bac54067349a387ed427407e08896f2d74e05666c1342db3a27264c" => :mavericks
  end

  depends_on :xcode => "6.0"

  def install
    system "./scripts/build.sh", "XT_INSTALL_ROOT=#{libexec}"
    bin.install_symlink "#{libexec}/bin/xctool"
  end

  test do
    system "(#{bin}/xctool -help; true)"
  end
end
