class Zpaq < Formula
  desc "Incremental, journaling command-line archiver"
  homepage "http://mattmahoney.net/dc/zpaq.html"
  url "http://mattmahoney.net/dc/zpaq705.zip"
  sha256 "d8abe3e3620d4c6f3ddc1da149acffa4c24296fd9c74c9d7b62319e308b63334"
  version "7.05"

  head "https://github.com/zpaq/zpaq.git"

  bottle do
    cellar :any
    sha256 "bdd4716595b8eed1c52d2a2ef43abb095a996d05a0489f81f0b22ae43a26d51d" => :yosemite
    sha256 "a71ad4808da8c69844f72322ff7633b895d034028129b30c3d25409d91bd4213" => :mavericks
    sha256 "a2d2215b51cc18370f5ebe700160d1d7143ce5d680b2365a5adb4bb1622d06fc" => :mountain_lion
  end

  def install
    system "make"
    include.install "libzpaq.h"
    bin.install "zpaq"

    system "pod2man", "zpaq.pod", "zpaq.1"
    man1.install "zpaq.1"
  end

  test do
    archive = testpath/"test.zpaq"
    zpaq = bin/"zpaq"
    system zpaq, "a", archive, "#{include}/libzpaq.h"
    system zpaq, "l", archive
    assert_equal "7kSt", archive.read(4)
  end
end
