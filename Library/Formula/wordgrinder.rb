class Wordgrinder < Formula
  desc "Unicode-aware character cell word processor that runs in a terminal"
  homepage "http://cowlark.com/wordgrinder"
  url "https://github.com/davidgiven/wordgrinder/archive/0.6.tar.gz"
  sha256 "3459cab32ca89d8585aa96ef0b9db2ac3802773223786991e48b3c62e2ee7eed"
  head "https://github.com/davidgiven/wordgrinder"

  depends_on "lua"

  def install
    system "make", "PREFIX=#{prefix}"
    bin.install "bin/wordgrinder" => "wordgrinder"
    bin.install "bin/wordgrinder-static" => "wordgrinder-static"
    bin.install "bin/wordgrinder-debug" => "wordgrinder-debug"
    man1.install "wordgrinder.man" => "wordgrinder.1"
  end

  test do
    system "wordgrinder", "--help"
  end
end
