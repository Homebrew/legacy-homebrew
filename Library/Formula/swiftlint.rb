class Swiftlint < Formula
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.1.1", :revision => "76939117e8db4cff7ccd5d362340cbc6a7af878c"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "1d6c4631e894635fbbbb6d006e5e186452cf40ea0e2e5d98442dda2bda6efd20" => :yosemite
  end

  depends_on :xcode => ["6.3", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation\n"
    system "#{bin}/swiftlint"
  end
end
