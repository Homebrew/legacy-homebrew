class Jshon < Formula
  desc "Parse, read, and create JSON from the shell"
  homepage "http://kmkeen.com/jshon/"
  url "http://kmkeen.com/jshon/jshon.tar.gz"
  version "8"
  sha256 "bb8ffdbda89a24f15d23af06d23fc4a9a4319503eb631cc64a5eb4c25afd45fb"

  depends_on "jansson"

  def install
    system "make"
    bin.install "jshon"
    man1.install "jshon.1"
  end

  test do
    assert_equal "3", pipe_output("#{bin}/jshon -l", "[true,false,null]").strip
  end
end
