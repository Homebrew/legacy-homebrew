class Nimrod < Formula
  homepage "http://nim-lang.org/"
  url "http://nim-lang.org/download/nim-0.11.0.tar.xz"
  sha1 "5cbad487c94d0dd4b8cbd52486dd43b1ccf671fb"
  head "https://github.com/Araq/Nim.git", :branch => "devel"

  bottle do
    cellar :any
    sha1 "d982481f09e677a7cf707d0cfe214c388ee0de9d" => :yosemite
    sha1 "f481f9c658255a480dd562552e2f67d1bdf2b1f2" => :mavericks
    sha1 "496b2e4b50e69d73e1299d478ab0a1c94c1804ee" => :mountain_lion
  end

  def install
    system "/bin/sh", "build.sh"
    system "/bin/sh", "install.sh", prefix

    (prefix/"nim/bin").install "bin/nim"
    (prefix/"nim").install "compiler"
    bin.install_symlink prefix/"nim/bin/nim"
    bin.install_symlink prefix/"nim/bin/nim" => "nimrod"
  end

  test do
    (testpath/"hello.nim").write <<-EOS.undent
      echo("hello")
    EOS
    assert_equal "hello\n", `#{bin}/nim compile --verbosity:0 --run #{testpath}/hello.nim`
    assert_equal 0, $?.exitstatus
  end
end
