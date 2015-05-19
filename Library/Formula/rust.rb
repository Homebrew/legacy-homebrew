class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage 'http://www.rust-lang.org/'

  stable do
    url 'https://static.rust-lang.org/dist/rustc-1.0.0-src.tar.gz'
    sha256 'c304cbd4f7b25d116b73c249f66bdb5c9da8645855ce195a41bda5077b995eba'

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", :revision => "a48358155c90467ed9c897930dd0da4614605dac"
    end

    # name includes date to satisfy cache
    resource "cargo-nightly-2015-05-14" do
      url "https://static-rust-lang-org.s3.amazonaws.com/cargo-dist/2015-05-14/cargo-nightly-x86_64-apple-darwin.tar.gz"
      sha256 "46403af9abb0dd0d9e3c31c20aa2508878ae1e8d0f1e7913addbfc08605b9733"
    end

    # name includes date to satisfy cache
    resource "rustc-nightly-2015-05-14" do
      url "https://static-rust-lang-org.s3.amazonaws.com/dist/2015-05-14/rustc-nightly-x86_64-apple-darwin.tar.gz"
      sha256 "1f7f447e369190d4d0d3f8c516e6c4d07e458f258f71737422b3f542b6d4da1e"
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
        resource("rustc-nightly-2015-05-14").stage do
          system "./install.sh", "--prefix=#{cargo_stage_path}/rustc"
        end

        resource("cargo-nightly-2015-05-14").stage do
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
