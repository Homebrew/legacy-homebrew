require "formula"

class Fsw < Formula
  homepage "http://emcrisostomo.github.io/fsw/"
  url "https://github.com/emcrisostomo/fsw/releases/download/v1.3.1/fsw-1.3.1.tar.gz"
  sha1 "f9c0f1c75e72f1a29c1e8433ca3f7aa408a94c4e"

  def install
    ENV.append "CXXFLAGS", "-stdlib=libc++"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    io = IO.popen("fsw test")
    (testpath/'test').write('foo')
    assert_equal File.expand_path("test"), io.gets.strip
    Process.kill "INT", io.pid
    Process.wait io.pid
  end
end
