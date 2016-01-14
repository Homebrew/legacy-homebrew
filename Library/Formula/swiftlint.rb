class Swiftlint < Formula
  desc "Experimental tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.5.6", :revision => "cff056bf0de16d934b3657807f7c4cb4d69dfd21"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "0c0fd8b176f70b9eacc4eabcea885841a0825ee85f034263f99fdfd8a13ba3f9" => :el_capitan
    sha256 "d70836b5fe8f7e34cd8f330fd179bfec2d62f77da51b6422c3c2596c7af41c39" => :yosemite
  end

  depends_on :xcode => ["7.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation\n"
    system "#{bin}/swiftlint"
  end
end
