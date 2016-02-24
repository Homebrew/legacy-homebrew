class Fsw < Formula
  desc "File change monitor with multiple backends"
  homepage "https://emcrisostomo.github.io/fsw/"
  url "https://github.com/emcrisostomo/fsw/releases/download/1.3.9/fsw-1.3.9.tar.gz"
  sha256 "9222f76f99ef9841dc937a8f23b529f635ad70b0f004b9dd4afb35c1b0d8f0ff"

  bottle do
    sha256 "8f2bef3c6a8c71c9eaf476cfa035c4c5f4a7ade3792260978d6eb43d68c36915" => :yosemite
    sha256 "e6154369d0f4383524024c58a87a7903545db37244b7311bcb4ffda2ecb0db2d" => :mavericks
    sha256 "365500d0a239aee9df902e24d5cefba97ab4a07c2d7976f58a1383bbe6f490a8" => :mountain_lion
  end

  def install
    ENV.append "CXXFLAGS", "-stdlib=libc++"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    io = IO.popen("fsw test")
    (testpath/"test").write("foo")
    assert_equal File.expand_path("test"), io.gets.strip
    Process.kill "INT", io.pid
    Process.wait io.pid
  end
end
