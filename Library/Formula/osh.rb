class Osh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "http://v6shell.org"
  url "http://v6shell.org/src/osh-20160108.tar.gz"
  sha256 "51980473429cd1f8dad255c30749b8588278caf42b28185e22b9455e8f381bf7"
  head "https://github.com/JNeitzel/v6shell.git"

  bottle do
    sha256 "554a72a3c717bf1f29df8d7d15be31aed86d9538b4924bb242545b5c0891739b" => :yosemite
    sha256 "6f70c00a27888c8c9b12ba28d872942a062aefd85180253d928afb50fa06a506" => :mavericks
    sha256 "5a7d41cd9a354d647faff4021a7601b756af0255f906354bb3f79a33639e3ffc" => :mountain_lion
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
