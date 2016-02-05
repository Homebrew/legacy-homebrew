class Clog < Formula
  desc "Colorized pattern-matching log tail utility."
  homepage "https://tasktools.org/projects/clog.html"
  url "https://tasktools.org/download/clog-1.2.1.tar.gz"
  sha256 "880cfe248326a5c6f7c2a183008c76fae8b78c45f6e5795f74d02627e634f29d"
  head "https://git.tasktools.org/scm/ut/clog.git", :branch => "1.3.0", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "4467cfd645790f505f60ad798d9cf517057b0bad6829ae54bec0309331d55ed7" => :el_capitan
    sha256 "3ea89c398cdf711a1781ccb23d3b1e092fef36f1ca66b64c615060732763af3a" => :yosemite
    sha256 "d4907545ee0aa42a38cac90161061004a20a51c002e800bb4d725c5230b241e1" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Next step is to create a .clogrc file in your home directory. See 'man clog'
    for details and a sample file.
    EOS
  end

  test do
    # Create a rule to suppress any line containing the word 'ignore'
    (testpath/".clogrc").write "default rule /ignore/       --> suppress"

    # Test to ensure that a line that does not match the above rule is not suppressed
    assert_equal "do not suppress", pipe_output("#{bin}/clog --file #{testpath}/.clogrc", "do not suppress").chomp

    # Test to ensure that a line that matches the above rule is suppressed
    assert_equal "", pipe_output("#{bin}/clog --file #{testpath}/.clogrc", "ignore this line").chomp
  end
end
