class Wry < Formula
  desc "Command-line App.net tool"
  homepage "http://grailbox.com/wry/"
  url "https://github.com/hoop33/wry/archive/v1.8.2.tar.gz"
  sha256 "bfc277b5425176c632716def46d8c8b6c8257eb764cf4cbd231de6f55c62c5f2"

  head "https://github.com/hoop33/wry.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8274aae5fc7f8ed914f2fd1c99c505f53532709831a41412949d1a133ddcce1f" => :el_capitan
    sha256 "bb692f4c4690c6a312abec61abf69c279880fbdf620c01f2f61d686a9e04a080" => :mavericks
    sha256 "e318cba1a286d9d415f45c3f9729a27a8170713b1d06c897567dd5989d4acf14" => :mountain_lion
    sha256 "62d8ccef8fe23dbc90b9f36d4693922a7884f69ad9276e1dd2e094a67c1fbbf2" => :lion
  end

  depends_on :macos => :lion
  depends_on :xcode => :build

  def install
    xcodebuild "-target", "wry", "-configuration", "Release", "SYMROOT=build", "OBJROOT=objroot"
    bin.install "build/Release/wry"
  end
end
