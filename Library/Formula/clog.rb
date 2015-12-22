class Clog < Formula
  desc "Colorized pattern-matching log tail utility."
  homepage "http://tasktools.org/projects/clog.html"
  url "http://tasktools.org/download/clog-1.2.1.tar.gz"
  sha256 "880cfe248326a5c6f7c2a183008c76fae8b78c45f6e5795f74d02627e634f29d"
  head "https://git.tasktools.org/scm/ut/clog.git", :branch => "1.3.0", :shallow => false

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
