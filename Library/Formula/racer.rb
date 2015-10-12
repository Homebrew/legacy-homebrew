class Racer < Formula
  desc "Rust Code Completion utility"
  homepage "https://github.com/phildawes/racer"
  url "https://github.com/phildawes/racer/archive/v1.0.0.tar.gz"
  sha256 "78895296ed688eeccbaf7745235f0fc503407bfa718f53583a4dcc9e1246b7f5"

  keg_only "You should set path in your special editor which use racer"

  option "without-src", "Do not get rust source for racer from www.rust-lang.org"

  depends_on "rust" => :build

  resource "rustsrc" do
    url "https://static.rust-lang.org/dist/rustc-1.3.0-src.tar.gz"
    sha256 "ea02d7bc9e7de5b8be3fe6b37ea9b2bd823f9a532c8e4c47d02f37f24ffa3126"
  end

  def install
    if build.with?("src")
      resource("rustsrc").stage do
        rm_rf "./src/llvm/test/"
        (prefix/"rust-src").install Dir["./src/*"]
      end
    end

    system "cargo", "build", "--release"
    bin.install "target/release/racer"
  end

  def caveats; <<-EOS.undent
    Rust source is installed at #{opt_prefix}/rust-src by default.
    You should export RUST_SRC_PATH=#{opt_prefix}/rust-src or set
    rust source path in your special editor which use racer
    EOS
  end

  test do
    ENV["RUST_SRC_PATH"] = "#{opt_prefix}/rust-src"
    assert_match /^MATCH BufReader/, shell_output("#{bin}/racer complete std::io::B")
  end
end
