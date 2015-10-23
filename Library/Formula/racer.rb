class Racer < Formula
  desc "Rust Code Completion utility"
  homepage "https://github.com/phildawes/racer"

  url "https://github.com/phildawes/racer/archive/v1.0.0.tar.gz"
  sha256 "78895296ed688eeccbaf7745235f0fc503407bfa718f53583a4dcc9e1246b7f5"
  head "https://github.com/phildawes/racer.git"

  option "without-src", "Do not get rust source for racer from www.rust-lang.org"
  depends_on "rust" => :build

  resource "rustsrc" do
    url "https://static.rust-lang.org/dist/rustc-1.3.0-src.tar.gz"
    sha256 "ea02d7bc9e7de5b8be3fe6b37ea9b2bd823f9a532c8e4c47d02f37f24ffa3126"
  end

  def install
    if build.with?("src")
      resource("rustsrc").stage do
        rm_rf "src/llvm"
        rm_rf "src/test"
        (share/"rust-#{resource("rustsrc").version}").install Dir["./src/*"]
      end
    end

    system "cargo", "build", "--release"
    libexec.install "target/release/racer"
  end

  def caveats
    if build.with?("src")
      <<-EOS.undent
      racer in installed at #{opt_prefix}/libexec/racer.
      Rust source (version:#{resource("rustsrc").version}) is installed at #{opt_prefix}/share/rust-#{resource("rustsrc").version}
      EOS
    else
      <<-EOS.undent
      racer in installed at #{opt_prefix}/libexec/racer.
      EOS
    end
  end

  test do
    ENV["RUST_SRC_PATH"] = "#{opt_prefix}/share/rust-#{resource("rustsrc").version}"
    assert_match /^MATCH BufReader/, shell_output("#{libexec}/racer complete std::io::B")
  end
end
