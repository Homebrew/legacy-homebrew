class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/Hackerpilot/dfmt"
  url "https://github.com/Hackerpilot/dfmt.git",
      :tag => "v0.4.1",
      :revision => "5ce683bab21598db69e399768ecd143caa57ef34"
  bottle do
    sha256 "538c0e8888ba6192758525eeea3da9cea47d85f8e137485eebec0e29d949309b" => :el_capitan
    sha256 "3ec2b8ed4813617fb871c8913e1deffd25496882e6106ff97ce9ea208099817d" => :yosemite
    sha256 "98f64ee8ce26406649e9092da9a17d92628fae2afd056d7d8f65f499db19ce91" => :mavericks
  end

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
