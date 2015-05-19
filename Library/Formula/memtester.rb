class Memtester < Formula
  desc "Utility for testing the memory subsystem"
  homepage "http://pyropus.ca/software/memtester/"
  url "http://pyropus.ca/software/memtester/old-versions/memtester-4.3.0.tar.gz"
  sha256 "f9dfe2fd737c38fad6535bbab327da9a21f7ce4ea6f18c7b3339adef6bf5fd88"

  bottle do
    cellar :any
    sha256 "fc38d748b19b83c69547ab95bae6adce7009d14b6b21668e20417e7596691c6e" => :yosemite
    sha256 "e2690d42f2744e37e9f0e119736653a92d0d1be2d10aed7ebc7364dad0eeb640" => :mavericks
    sha256 "41a55e47f94006bd7b8a1876b3788811b98d383738dd7153f9c1f1e527322cec" => :mountain_lion
  end

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "INSTALLPATH", prefix
      s.gsub! "man/man8", "share/man/man8"
    end
    inreplace "conf-ld", " -s", ""
    system "make", "install"
  end

  test do
    system bin/"memtester", "1", "1"
  end
end
