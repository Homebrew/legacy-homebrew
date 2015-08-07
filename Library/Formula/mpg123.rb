class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "http://www.mpg123.de/"
  url "http://www.mpg123.de/download/mpg123-1.22.3.tar.bz2"
  mirror "http://mpg123.orgis.org/download/mpg123-1.22.3.tar.bz2"
  sha256 "23d2a843c3efc746a326eb4e56d5488b4c67fa6c3c7c71f4d26d98ee4c1f5c2d"

  bottle do
    cellar :any
    sha256 "4c609f1a3f05bb39d1897531f7aae4b164e40bb86d2f0347002f8149515344ae" => :yosemite
    sha256 "f82ce3c8ad1175ca652f9db8fdd69364675c2391dc82e9b2fbfd09a27138cc72" => :mavericks
    sha256 "f01408cc9e8a9cfac9dc2251e8010fb40f56700785373ab26690cb4432ee375b" => :mountain_lion
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-default-audio=coreaudio",
            "--with-module-suffix=.so"]

    if MacOS.prefer_64_bit?
      args << "--with-cpu=x86-64"
    else
      args << "--with-cpu=sse_alone"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mpg123", test_fixtures("test.mp3")
  end
end
