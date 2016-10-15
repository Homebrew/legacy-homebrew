require "open3"

class Matcher < Formula
  homepage "https://github.com/burke/matcher"
  url "https://github.com/burke/matcher/archive/1.0.0.tar.gz"
  sha1 "47c4c47de5a94f36366c09d10508a338610b183d"

  def install
    system "make"
    system "make", "install"
  end

  test do
    !!(Open3.capture3('echo "hello\nworld\nhello" | matcher ll | wc -l')[0] =~ /2/)
  end
end
