class Bup < Formula
  desc "Backup tool"
  homepage "https://github.com/bup/bup"
  url "https://github.com/bup/bup/archive/0.27.tar.gz"
  sha256 "ae8a744a3415ce4766d1d896f3d48b9b2ae6167c7bc65d8d1a112f37b42720fb"

  head "https://github.com/bup/bup.git"

  bottle do
    cellar :any
    sha256 "3cf4a28be9d177fe8db9be897981a61fddb98c5b4e98bddc6cc2b5a9967324b0" => :yosemite
    sha256 "e37ae889d53612d81f29a747367595f8ef17e04aea91aee2a564d452c9b43cc1" => :mavericks
    sha256 "9c7b4eda48367a6c62786e8c74aa1b455ecc9525a6431d2a2837d13fb592c0f6" => :mountain_lion
  end

  option "with-test", "Run unit tests after compilation"
  option "with-pandoc", "Build and install the manpages"

  deprecated_option "run-tests" => "with-test"
  deprecated_option "with-tests" => "with-test"

  depends_on "pandoc" => [:optional, :build]

  def install
    system "make"
    system "make", "test" if build.with? "test"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
  end

  test do
    system bin/"bup", "init"
    assert File.exist?("#{testpath}/.bup")
  end
end
