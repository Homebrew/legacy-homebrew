class Cocoapods < Formula
  homepage "https://github.com/keith/cocoapods/"
  url "http://keith.github.io/CocoaPods/cocoapods-0.37.2.tar.gz"
  sha1 "f727a8027a747f01323ee1188c4ce654731e3e51"

  def install
    prefix.install "vendor"
    prefix.install "lib" => "rubylib"

    bin.install "src/pod"
  end

  test do
    system "#{bin}/cocoapods", "--version"
  end
end
