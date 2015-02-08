class Osh < Formula
  homepage "http://v6shell.org"
  url "http://v6shell.org/src/osh-20150115.tar.gz"
  sha1 "1876e56b82ebad814aa74c62a2fb8a93947e2a65"
  head "https://github.com/JNeitzel/v6shell.git"

  option "with-examples", "Build with shell examples"

  resource "examples" do
    url "http://v6shell.org/v6scripts/v6scripts-20150201.tar.gz"
    sha1 "43da6a1d0f6810f2311786e04870c3896b6904c9"
  end

  bottle do
    cellar :any
    sha1 "3d552072c3b4e480ddba423af918d4e2d3d0cc4b" => :mavericks
    sha1 "0f54312ecae702162e4e5326f1561215bee7a775" => :mountain_lion
    sha1 "122f3ff69d9d6660de402047faec79d6adfa9441" => :lion
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "SYSCONFDIR=#{etc}"

    if build.with? "examples"
      resource("examples").stage do
        ENV.prepend_path "PATH", bin
        system "./INSTALL", libexec
      end
    end
  end

  test do
    assert_match /Homebrew!/, shell_output("#{bin}/osh -c 'echo Homebrew!'").strip

    if build.with? "examples"
      ENV.prepend_path "PATH", libexec
      assert_match /1 3 5 7 9 11 13 15 17 19/, shell_output("#{libexec}/counts").strip
    end
  end
end
