class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.3.0-src.tar.gz"
    sha256 "ea02d7bc9e7de5b8be3fe6b37ea9b2bd823f9a532c8e4c47d02f37f24ffa3126"

    resource "cargo" do
      # git required because of submodules
      url "https://github.com/rust-lang/cargo.git", :tag => "0.5.0", :revision => "8d21fd21a6b20056e9b5745e4e3f3b4279dc7fe4"
    end

    # name includes date to satisfy cache
    resource "cargo-nightly-2015-09-17" do
      url "https://static-rust-lang-org.s3.amazonaws.com/cargo-dist/2015-09-17/cargo-nightly-x86_64-apple-darwin.tar.gz"
      sha256 "02ba744f8d29bad84c5e698c0f316f9e428962b974877f7f582cd198fdd807a8"
    end
  end

  head do
    url "https://github.com/rust-lang/rust.git"
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git"
    end
  end

  bottle do
    sha256 "705f4d0a6641776126e2d2b1af399fb84002d4d22cad564d25bfc9a1c45ae717" => :el_capitan
    sha256 "c9bb07ae7830548c875f6d65bbc09ecde943a2c87b5564a8e63dac5e08ca276d" => :yosemite
    sha256 "74a4271c86bc8a5ed0bfaac0cdd9d793b8f2c23e845f1107c1709d8bfca0d6f6" => :mavericks
    sha256 "bfa7e32786aef2065c14fc8ca1464bc59301f4479462adefba99b491a9dc74be" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  # According to the official readme, GCC 4.7+ is required
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--disable-rpath" if build.head?
    args << "--enable-clang" if ENV.compiler == :clang
    if build.head?
      args << "--release-channel=nightly"
    else
      args << "--release-channel=stable"
    end
    system "./configure", *args
    system "make"
    system "make", "install"

    resource("cargo").stage do
      cargo_stage_path = pwd

      if build.stable?
        resource("cargo-nightly-2015-09-17").stage do
          system "./install.sh", "--prefix=#{cargo_stage_path}/target/snapshot/cargo"
          # satisfy make target to skip download
          touch "#{cargo_stage_path}/target/snapshot/cargo/bin/cargo"
        end
      end

      system "./configure", "--prefix=#{prefix}", "--local-rust-root=#{prefix}"
      system "make"
      system "make", "install"
    end

    rm_rf prefix/"lib/rustlib/uninstall.sh"
    rm_rf prefix/"lib/rustlib/install.log"
  end

  test do
    system "#{bin}/rustdoc", "-h"
    (testpath/"hello.rs").write <<-EOS.undent
    fn main() {
      println!("Hello World!");
    }
    EOS
    system "#{bin}/rustc", "hello.rs"
    assert_equal "Hello World!\n", `./hello`
    system "#{bin}/cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!",
                 (testpath/"hello_world").cd { `#{bin}/cargo run`.split("\n").last }
  end
end
