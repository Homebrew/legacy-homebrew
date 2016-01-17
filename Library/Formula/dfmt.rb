class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/Hackerpilot/dfmt"
  url "https://github.com/Hackerpilot/dfmt.git",
      :tag => "v0.4.4",
      :revision => "c53eb5e0e4a6bb494dccc1eb1ff3e6f4dc820bfa"

  head "https://github.com/Hackerpilot/dfmt.git", :shallow => false

  bottle do
    sha256 "d8a2967609049e5804cffae5b980e63d36bc483125e8d174381e8c8d06641820" => :el_capitan
    sha256 "15f60ab3dc90d0a55f87024bcb46eea6cee75a3ddc95f49bbaa69ba131ab8e01" => :yosemite
    sha256 "e8824104b479775e9f164d137f3be4ba45a54b58e4358e59200efcf2eeae69cd" => :mavericks
  end

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
