class Fsw < Formula
  desc "File change monitor with multiple backends"
  homepage "https://emcrisostomo.github.io/fsw/"
  url "https://github.com/emcrisostomo/fsw/releases/download/1.3.9/fsw-1.3.9.tar.gz"
  sha1 "bd2b230dc800946941d89512ce9ae8669365d21a"

  bottle do
    sha1 "37e0d950a4c82a603788007b9a40aadb6ebf9373" => :yosemite
    sha1 "fb0448832cd6e1c9a1a834c6ba64095572a367d1" => :mavericks
    sha1 "7dce3e9f85da19d300dc1f2ebe9ac1af0aa39ada" => :mountain_lion
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
