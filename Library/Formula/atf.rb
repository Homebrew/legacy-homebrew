class Atf < Formula
  desc "ATF: Automated Testing Framework"
  homepage "https://github.com/jmmv/atf"
  url "https://github.com/jmmv/atf/releases/download/atf-0.21/atf-0.21.tar.gz"
  sha256 "92bc64180135eea8fe84c91c9f894e678767764f6dbc8482021d4dde09857505"

  bottle do
    sha1 "5688f4c5066575165a7b9daf9aee4cc21f639656" => :yosemite
    sha1 "6b3e5320b3cdc1b56556f1f41f819f684055c551" => :mavericks
    sha1 "b7b43370c8bcf25b46c77b298b05e0d53098f7ad" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make"
    ENV.j1
    system "make", "install"
  end
end
