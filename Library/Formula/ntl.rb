require "formula"

class Ntl < Formula
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-6.2.1.tar.gz"
  sha1 "3b9ab3bedb0b2e9b5ee322d60745be5caf1c743f"

  bottle do
    cellar :any
    sha1 "b55331990e2df310d694d5ae67dc3a55d6f18fd1" => :mavericks
    sha1 "bd1f0789b9ebefb00eabd5d9de5f5dc2fe08bbc7" => :mountain_lion
    sha1 "0f7793a186aca6d6ea229b678575a008d3e1911b" => :lion
  end

  def install
    cd "src" do
      system "./configure", "PREFIX=#{prefix}"
      system "make"
      system "make", "check"
      system "make", "install"
    end
  end
end
