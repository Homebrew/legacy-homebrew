class GooglePerftools < Formula
  homepage "http://code.google.com/p/gperftools/"
  url "https://googledrive.com/host/0B6NtGsLhIcf7MWxMMF9JdTN3UVk/gperftools-2.4.tar.gz"
  sha1 "13b904d0d1f220e43e4495f3403ee280c6da26ea"

  bottle do
    cellar :any
    sha1 "8449da34214f2a095d8f41c3d63b0d0832e5e8e8" => :yosemite
    sha1 "87000f9e996ad5c6f14c4489df7152740c6a0464" => :mavericks
    sha1 "a518d03fe9773c34d337a81023afae873e2abced" => :mountain_lion
  end

  fails_with :llvm do
    build 2326
    cause "Segfault during linking"
  end

  def install
    ENV.append_to_cflags "-D_XOPEN_SOURCE"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
