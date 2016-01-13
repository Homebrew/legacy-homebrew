class Osh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "http://v6shell.org"
  url "http://v6shell.org/src/osh-20160108.tar.gz"
  sha256 "51980473429cd1f8dad255c30749b8588278caf42b28185e22b9455e8f381bf7"
  head "https://github.com/JNeitzel/v6shell.git"

  bottle do
    sha256 "abcfe34bbddad2d1dea4da6e8a852a9cd63df92fcdc67de01e77c6b0173922be" => :el_capitan
    sha256 "9cdf662f481f3d5903dc44bfe1b8085074d3053a4612a59f830e1c4c58fd7409" => :yosemite
    sha256 "1ca3cd79dc33ec932357ceb64ad5f05c002d7c6d19f6603c98d15415255efacb" => :mavericks
  end

  option "with-examples", "Build with shell examples"

  resource "examples" do
    url "http://v6shell.org/v6scripts/v6scripts-20150201.tar.gz"
    sha256 "411184449da48c59c9f341de748b1b6ea2a1c898848bf3bbf2b523e33ef62518"
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
