class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/Hackerpilot/dfmt"
  url "https://github.com/Hackerpilot/dfmt.git",
      :tag => "v0.4.1",
      :revision => "5ce683bab21598db69e399768ecd143caa57ef34"
  head "https://github.com/Hackerpilot/dfmt.git", :shallow => false

  depends_on "dmd" => :build

  def install
    system "make"
    bin.install "bin/dfmt"
  end

  test do
    (testpath/"test.d").write <<-EOS.undent
    import std.stdio; void main() { writeln("Hello, world without explicit compilations!"); }
    EOS

    expected = <<-EOS.undent
    import std.stdio;

    void main()
    {
        writeln("Hello, world without explicit compilations!");
    }
    EOS

    system "#{bin}/dfmt", "-i", "test.d"

    assert_equal expected, (testpath/"test.d").read
  end
end
