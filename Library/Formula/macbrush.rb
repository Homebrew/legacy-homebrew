class Macbrush < Formula
  desc "Keeping OSX directories clear of temporary files"
  homepage "http://nils-tekampe.github.io/MacBrush"
  url "https://github.com/nils-tekampe/MacBrush/archive/0.12.tar.gz"
  sha256 "ed08874d9c2059a81356419d29d9ff603b4810baea7742a2132dbdfaee064414"

  depends_on :xcode => :build

  def install
    cd "macbrush"
    xcodebuild  "clean"
    xcodebuild 
    bin.install "./build/Release"
  end
  test do
  mkdir "test"
  touch "./test/.DS_Store"
  macbrush "--verbose --skip-observation ./test"
  end
end
