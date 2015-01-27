class Fsw < Formula
  homepage "http://emcrisostomo.github.io/fsw/"
  url "https://github.com/emcrisostomo/fsw/releases/download/1.3.9/fsw-1.3.9.tar.gz"
  sha1 "bd2b230dc800946941d89512ce9ae8669365d21a"

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
