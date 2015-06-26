class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage 'http://www.rust-lang.org/'

  stable do
    url 'https://static.rust-lang.org/dist/rustc-1.1.0-src.tar.gz'
    sha256 'cb09f443b37ec1b81fe73c04eb413f9f656859cf7d00bc5088008cbc2a63fa8a'

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", :revision => "b030d35d5cf6b35bf8a6bfd218ab4df9d6a86361"
    end

    # name includes date to satisfy cache
    resource "cargo-nightly-2015-06-25" do
      url "https://static-rust-lang-org.s3.amazonaws.com/cargo-dist/2015-06-25/cargo-nightly-x86_64-apple-darwin.tar.gz"
      sha256 "b2e07bbee79cb8ad1e4f91a43cc3d93603e068a46b89bbe934d01ff97bfb0060"
    end

    # name includes date to satisfy cache
    resource "rustc-nightly-2015-06-25" do
      url "https://static-rust-lang-org.s3.amazonaws.com/dist/2015-06-25/rustc-nightly-x86_64-apple-darwin.tar.gz"
      sha256 "c4eb0a639b6deb3e2aceb1713afe6570118d1055bf189f1057a839238dbe7165"
    end
  end

  head do
    url "https://github.com/rust-lang/rust.git"
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git"
    end
  end

  bottle do
    sha256 "a4768e9bf0fb5ddc3860854c9be392e270627208b18fc3f0d5440b0d07338e7e" => :yosemite
    sha256 "e6a43e8d0870793a12f6981facf6614d51965f48b52b90061f660c31b99bb826" => :mavericks
    sha256 "dc1c3864cfb62b884857d3c9b20c81bd7e2289098aaa6adc3f87034add9b721b" => :mountain_lion
  end

  depends_on "openssl"
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

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
    system "make install"

    resource("cargo").stage do
      cargo_stage_path = pwd

      if build.stable?
        resource("rustc-nightly-2015-06-25").stage do
          system "./install.sh", "--prefix=#{cargo_stage_path}/rustc"
        end

        resource("cargo-nightly-2015-06-25").stage do
          system "./install.sh", "--prefix=#{cargo_stage_path}/target/snapshot/cargo"
          # satisfy make target to skip download
          touch "#{cargo_stage_path}/target/snapshot/cargo/bin/cargo"
        end
      end

      args = ["--prefix=#{prefix}"]

      if build.head?
        args << "--local-rust-root=#{prefix}"
      else
        args << "--local-rust-root=#{cargo_stage_path}/rustc"
      end

      system "./configure", *args
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
