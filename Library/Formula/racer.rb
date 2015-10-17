class Racer < Formula
  desc "Rust Code Completion utility"
  homepage "https://github.com/phildawes/racer"

  stable do
    url "https://github.com/phildawes/racer/archive/v1.0.0.tar.gz"
    sha256 "78895296ed688eeccbaf7745235f0fc503407bfa718f53583a4dcc9e1246b7f5"
  end

  head do
    url "https://github.com/phildawes/racer.git"
  end

  option "without-src", "Do not get rust source for racer from www.rust-lang.org"

  depends_on "rust" => :build

  resource "rustsrc" do
    url "https://static.rust-lang.org/dist/rustc-1.3.0-src.tar.gz"
    sha256 "ea02d7bc9e7de5b8be3fe6b37ea9b2bd823f9a532c8e4c47d02f37f24ffa3126"
  end

  def install
    if build.with?("src")
      resource("rustsrc").stage do
        Dir.glob(["src/llvm/*", "src/test/*"]) do |f|
          if File.directory?(f)
            rm_r(f)
          else
            File.delete(f)
          end
        end
        (share/"rustsrc").install Dir["./src/*"]
      end
    end

    system "cargo", "build", "--release"
    libexec.install "target/release/racer"
  end

  def caveats; <<-EOS.undent
    racer in installed at #{opt_prefix}/libexec/racer, set it to path if needed.
    Rust source is installed at #{opt_prefix}/share/rustsrc by default.
    You should export RUST_SRC_PATH=#{opt_prefix}/share/rustsrc or set
    rust source path in your special editor which use racer
    EOS
  end

  test do
    ENV["RUST_SRC_PATH"] = "#{opt_prefix}/share/rustsrc"
    assert_match /^MATCH BufReader/, shell_output("#{libexec}/racer complete std::io::B")
  end
end
