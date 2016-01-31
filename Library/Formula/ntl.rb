class Ntl < Formula
  desc "C++ number theory library"
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-9.6.4.tar.gz"
  sha256 "c4a1f015a879b4a20f6b76a98eb6033a7936b0ff3b3f3ca6159d7e7b2afd89eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c3bea2a391524ab89eed9bdd6e1681c9cc8dff1f20b16564543605d916840f3" => :el_capitan
    sha256 "3a5850750bd79e76917902c718592c77a8032cd9a57e26c0f8d30449ee561f24" => :yosemite
    sha256 "8aafbccfe2b63c3c4d42c408155e1b18422ce03f60ef9bdae46b5c9c80942aa8" => :mavericks
  end

  depends_on "gmp"

  def install
    args = ["PREFIX=#{prefix}"]

    cd "src" do
      system "./configure", *args
      system "make"
      system "make", "check"
      system "make", "install"
    end
  end
end
