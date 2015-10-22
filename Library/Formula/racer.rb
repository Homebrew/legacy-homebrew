class Racer < Formula
  desc "Rust Code Completion utility"
  homepage "https://github.com/phildawes/racer"

  url "https://github.com/phildawes/racer/archive/v1.0.0.tar.gz"
  sha256 "78895296ed688eeccbaf7745235f0fc503407bfa718f53583a4dcc9e1246b7f5"
  head "https://github.com/phildawes/racer.git"

  option "without-src", "Do not get rust source for racer from www.rust-lang.org"
  option "with-beta-src", "Get beta version of rust source"
  option "with-nightly-src", "Get nightly version of rust source"
  depends_on "rust" => :build

  resource "rustsrc" do
    url "https://static.rust-lang.org/dist/rustc-1.3.0-src.tar.gz"
    sha256 "ea02d7bc9e7de5b8be3fe6b37ea9b2bd823f9a532c8e4c47d02f37f24ffa3126"
  end

  resource "rustsrc-beta" do
    url "https://static.rust-lang.org/dist/rustc-beta-src.tar.gz"
    sha256 "e393758a541b1e1859c17deb54a548eb076ab9a7901210ddb47b033aa2d16e79"
  end

  resource "rustsrc-nightly" do
    url "https://static.rust-lang.org/dist/rustc-nightly-src.tar.gz"
    sha256 "be004a627cff79e7eb3ef17b2b855d6a5ee2258246c56cd6812b900ddf5ee79c"
  end

  def install
    if build.with?("src")
      rustsource = resource("rustsrc")
      if build.with?("beta-src")
        rustsource = resource("rustsrc-beta")
      elsif build.with?("nightly-src")
        rustsource = resource("rustsrc-nightly")
      end
      rustsource.stage do
        rm_rf "src/llvm"
        rm_rf "src/test"
        (share/"rustsrc").install Dir["./src/*"]
      end
    end

    system "cargo", "build", "--release"
    libexec.install "target/release/racer"
  end

  def caveats
    if build.with?("src")
      rustsource = resource("rustsrc")
      if build.with?("beta-src")
        rustsource = resource("rustsrc-beta")
      elsif build.with?("nightly-src")
        rustsource = resource("rustsrc-nightly")
      end
      <<-EOS.undent
      racer in installed at #{opt_prefix}/libexec/racer.
      Rust source with version:#{rustsource.version} is installed at #{opt_prefix}/share/rustsrc.
      You should export RUST_SRC_PATH=#{opt_prefix}/share/rustsrc.
      EOS
    else
      <<-EOS.undent
      racer in installed at #{opt_prefix}/libexec/racer.
      EOS
    end
  end

  test do
    ENV["RUST_SRC_PATH"] = "#{opt_prefix}/share/rustsrc"
    assert_match /^MATCH BufReader/, shell_output("#{libexec}/racer complete std::io::B")
  end
end
