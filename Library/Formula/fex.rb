class Fex < Formula
  desc "Powerful field extraction tool"
  homepage "http://www.semicomplete.com/projects/fex/"
  url "https://semicomplete.googlecode.com/files/fex-2.0.0.tar.gz"
  sha1 "014938009ffe0b2ec3d1293154a22e4a40fee4a9"

  bottle do
    cellar :any
    sha1 "1ae0b6d8788ede53263fc5e0dea922444bab606b" => :yosemite
    sha1 "2759dee42d85788ba2dc04bdf6f85ad3f9eecd87" => :mavericks
    sha1 "5abfa033f2dbe1725633a0d4390ac6e558982187" => :mountain_lion
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_equal "foo", pipe_output("#{bin}/fex 1", "foo bar", 0).chomp
  end
end
