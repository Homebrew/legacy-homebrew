class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/Hackerpilot/dfmt"
  url "https://github.com/Hackerpilot/dfmt.git",
      :tag => "v0.4.4",
      :revision => "c53eb5e0e4a6bb494dccc1eb1ff3e6f4dc820bfa"

  head "https://github.com/Hackerpilot/dfmt.git", :shallow => false

  bottle do
    sha256 "0f66b0a057dd8f99ee1b481798318eb352901a3ea1969361ea4d6a791e68ab83" => :el_capitan
    sha256 "a72035ea39e035feadb8f64d5275114ec8391510801f9986bb1261ebd2191e65" => :yosemite
    sha256 "d306278e22b46e60b6474593e1107db753c4fefc907e66bd1f348cc29af0fc95" => :mavericks
  end

  devel do
    url "https://github.com/Hackerpilot/dfmt.git",
        :tag => "v0.5.0-beta3",
        :revision => "845358bb61603031b0817aed03097064c8f2553f"
    version "0.5.0-beta3"
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
