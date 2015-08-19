class Gcovr < Formula
  desc "Reports from gcov test coverage program"
  homepage "http://gcovr.com/"
  url "https://github.com/gcovr/gcovr/archive/3.2.tar.gz"
  sha256 "5a969caf61452705a39f6642f4707d23644bdd2e5ef913014bf95c4bd0263db6"
  head "https://github.com/gcovr/gcovr.git"

  def install
    libexec.install Dir["*"]
    bin.install_symlink "../libexec/scripts/gcovr"
  end

  test do
    (testpath/"example.c").write "int main() { return 0; }"
    system *%W[cc -fprofile-arcs -ftest-coverage -fPIC -O0 -o example example.c]
    assert_match "Code Coverage Report", shell_output("#{bin}/gcovr -r .")
  end
end
