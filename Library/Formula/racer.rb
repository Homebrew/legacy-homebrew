class Racer < Formula
  desc "Rust Code Completion utility"
  homepage "https://github.com/phildawes/racer"

  url "https://github.com/phildawes/racer/archive/v1.0.0.tar.gz"
  sha256 "78895296ed688eeccbaf7745235f0fc503407bfa718f53583a4dcc9e1246b7f5"
  head "https://github.com/phildawes/racer.git"

  option "with-1.4", "Get 1.4 version of rust source"
  option "with-1.3", "Get 1.3 version of rust source"
  option "with-1.2", "Get 1.2 version of rust source"
  option "without-rust", "Disable any version of rust source"

  depends_on "rust" => :build

  resource "rust-1.2" do
    url "https://static.rust-lang.org/dist/rustc-1.2.0-src.tar.gz"
    sha256 "ea6eb983daf2a073df57186a58f0d4ce0e85c711bec13c627a8c85d51b6a6d78"
  end

  resource "rust-1.3" do
    url "https://static.rust-lang.org/dist/rustc-1.3.0-src.tar.gz"
    sha256 "ea02d7bc9e7de5b8be3fe6b37ea9b2bd823f9a532c8e4c47d02f37f24ffa3126"
  end

  resource "rust-1.4" do
    url "https://static.rust-lang.org/dist/rustc-1.4.0-src.tar.gz"
    sha256 "1c0dfdce5c85d8098fcebb9adf1493847ab40c1dfaa8cc997af09b2ef0aa8211"
  end

  def install
    rustsources = []
    latestresource = resource("rust-1.4")
    if build.with?("1.4")
      rustsources.push(resource("rust-1.4"))
    end
    if build.with?("1.3")
      rustsources.push(resource("rust-1.3"))
    end
    if build.with?("1.2")
      rustsources.push(resource("rust-1.2"))
    end
    if rustsources.size == 0
      rustsources.push(latestresource)
    end
    if build.without?("rust")
      rustsources.clear
    end

    rustsources.each do |rustsource|
      rustsource.stage do
        rm_rf "src/llvm"
        rm_rf "src/test"
        (share/"rust-#{rustsource.version}").install Dir["./src/*"]
      end
    end

    system "cargo", "build", "--release", "--verbose"
    libexec.install "target/release/racer"
  end

  def caveats
    if build.with?("rust")
      <<-EOS.undent
      racer in installed at #{opt_prefix}/libexec/racer.
      Rust source is installed at #{opt_prefix}/share/rust-{version}.
      EOS
    else
      <<-EOS.undent
      racer in installed at #{opt_prefix}/libexec/racer.
      EOS
    end
  end

  test do
    ENV["RUST_SRC_PATH"] = nil
    assert_match /^RUST_SRC_PATH/, shell_output("#{libexec}/racer complete std::io::B", 1)
  end
end
