class Bup < Formula
  desc "Backup tool"
  homepage "https://github.com/bup/bup"
  url "https://github.com/bup/bup/archive/0.27.tar.gz"
  sha256 "ae8a744a3415ce4766d1d896f3d48b9b2ae6167c7bc65d8d1a112f37b42720fb"

  head "https://github.com/bup/bup.git"

  option "with-tests", "Run unit tests after compilation"
  option "with-pandoc", "Build and install the manpages"

  deprecated_option "run-tests" => "with-tests"

  depends_on "pandoc" => [:optional, :build]

  def install
    system "make"
    system "make", "test" if build.with? "tests"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
  end

  test do
    system bin/"bup", "init"
    assert File.exist?("#{testpath}/.bup")
  end
end
