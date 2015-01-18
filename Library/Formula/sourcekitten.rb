class Sourcekitten < Formula
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git", :tag => "0.3.0"
  head "https://github.com/jpsim/SourceKitten.git"

  depends_on :xcode => ["6.1.1", :build]

  def install
    # FIXME: Support installing with a custom TEMPORARY_FOLDER so that
    #        homebrew can automatically clean up the directory.
    #        https://github.com/jpsim/SourceKitten/issues/28
    system "make", "prefix_install", "PREFIX=#{prefix}"
    system "make", "clean" # remove temporary installation files in /tmp/SourceKitten.dst
  end

  test do
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
