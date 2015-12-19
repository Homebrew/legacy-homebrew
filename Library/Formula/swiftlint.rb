class Swiftlint < Formula
  desc "Experimental tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.5.2", :revision => "eab6bf50755c7778252f1363e977546949d6983d"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "0a0d83056f0c17a9711ab12197e1f537b7c91fa35b96e24a891c20cf7373a828" => :el_capitan
    sha256 "188a0765d7d88ed09973a5cc1abc6154b8866660b2b799b4b8a5f8e35ff13048" => :yosemite
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
