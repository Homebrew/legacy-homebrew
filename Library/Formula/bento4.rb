class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com"
  url "https://codeload.github.com/axiomatic-systems/Bento4/tar.gz/v1.4.3-607"
  version "1.4.3-607"
  sha256 "37d98fb105d5800e5e08f3cb304f8baeee020ea3599bf20cab2ff340737e5f45"
  head "https://github.com/axiomatic-systems/Bento4.git"

  depends_on :xcode => :build

  conflicts_with "gpac", :because => "gpac also ships a MP42aac binary"

  def install
    xcodebuild "-project",
      "Build/Targets/universal-apple-macosx/Bento4.xcodeproj",
      "SYMROOT=build"

    cd "Build/Targets/universal-apple-macosx/build/Release/" do
      lib.install("libBento4.a", "libBento4C.dylib")

      # Don't install directories or test files.
      binaries = Dir["*"].reject { |f| File.directory?(f) || f[/test/i] }

      bin.install(binaries)
    end
  end

  test do
    system "#{bin}/mp4tag", "--list-keys"
  end
end
