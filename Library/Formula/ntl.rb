class Ntl < Formula
  desc "C++ number theory library"
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-9.6.3.tar.gz"
  sha256 "59d59872ec5f3f0848aa0766aa46ead6ac041be73899f6e9b8d6a18af41f8136"

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
