class Nim < Formula
  desc "Statically typed, imperative programming language"
  homepage "http://nim-lang.org/"
  url "http://nim-lang.org/download/nim-0.12.0.tar.xz"
  sha256 "0fb860137f0888f6b1a593d9b115fd7057983b7355f4f9922bb82a49ac875235"
  head "https://github.com/Araq/Nim.git", :branch => "devel"

  bottle do
    cellar :any_skip_relocation
    sha256 "7eaf8f68a6f25158beaf059250f0b8a153ce06777463e692bed1b41efbc5acd4" => :el_capitan
    sha256 "9e3dc6f110d2e73ba02e256a12f76e2c085a9ea1ea764eaf858793a3e2d842b6" => :yosemite
    sha256 "c45bc468881f14d368a10049704be18cae380d7b6556318d28a009f5c18198cc" => :mavericks
  end

  def install
    if build.head?
      system "/bin/sh", "bootstrap.sh"
    else
      system "/bin/sh", "build.sh"
    end
    system "/bin/sh", "install.sh", prefix

    bin.install_symlink prefix/"nim/bin/nim"
    bin.install_symlink prefix/"nim/bin/nim" => "nimrod"
  end

  test do
    (testpath/"hello.nim").write <<-EOS.undent
      echo("hello")
    EOS
    assert_equal "hello", shell_output("#{bin}/nim compile --verbosity:0 --run #{testpath}/hello.nim").chomp
  end
end
