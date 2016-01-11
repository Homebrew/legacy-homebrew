class ClassDump < Formula
  desc "Utility for examining the Objective-C segment of Mach-O files"
  homepage "http://stevenygard.com/projects/class-dump/"

  stable do
    url "https://github.com/nygard/class-dump/archive/3.5.tar.gz"
    sha256 "94f5286c657dca02dbed4514b2dbd791b42ecef5122e3945a855caf8d1f65e64"

    # It uses the system OpenSSL and breaks if you try to feed it another.
    # Upstream have switched to CommonCrypto but no new release & still problems.
    # https://github.com/Homebrew/homebrew/issues/42384
    # https://github.com/nygard/class-dump/pull/58
    # Potential boneyard if not resolved soon - @DomT4 - November 2015.
    depends_on MaximumMacOSRequirement => :mavericks
  end

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "dd2ca9159871a0ecc7aedfab5dd0cdbec4a43ea321988c8eb1d1ba4a9c4bae19" => :mavericks
  end

  head do
    url "https://github.com/nygard/class-dump.git"

    # Removes the last references to libcrypto.
    patch do
      url "https://patch-diff.githubusercontent.com/raw/nygard/class-dump/pull/58.diff"
      sha256 "50c9af3c534f0803133e1f69ed820b5094b0b3adf0861c95a3488f8399974640"
    end
  end

  depends_on :macos => :mavericks
  depends_on :xcode => :build

  def install
    xcodebuild "-configuration", "Release", "SYMROOT=build", "PREFIX=#{prefix}", "ONLY_ACTIVE_ARCH=YES"
    bin.install "build/Release/class-dump"
  end
end
