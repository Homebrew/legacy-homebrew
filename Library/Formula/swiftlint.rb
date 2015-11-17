class Swiftlint < Formula
  desc "Experimental tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.2.0", :revision => "a71c9fbf015405de3ae2a92d051876074cfbf4ec"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "67c80a5bda6fc050ffda404bddd99143d04a4a0a10158f526d46e4ecee4ad37b" => :el_capitan
    sha256 "b02a94fc5e994bb939dbe425edef01cd819d31beb3126abc3f62158bafa8dc82" => :yosemite
  end

  depends_on :xcode => ["7.0", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation\n"
    system "#{bin}/swiftlint"
  end
end
