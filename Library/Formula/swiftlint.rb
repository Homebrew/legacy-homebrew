class Swiftlint < Formula
  desc "Experimental tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.5.0", :revision => "f3312926f6d274f14044c10334c306c7ed092c12"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "521cfb773447c79a59a8f7f9f307a53873ab73353e4d0814182cf643bb949d5f" => :el_capitan
    sha256 "e5f7664cc984b942a91d73bc4658b1dfdb5a2e8e6467de28d5e590ce6d5b6845" => :yosemite
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
