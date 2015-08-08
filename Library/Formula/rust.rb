class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.2.0-src.tar.gz"
    sha256 "ea6eb983daf2a073df57186a58f0d4ce0e85c711bec13c627a8c85d51b6a6d78"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", :revision => "425fd85ffd9d54ac9901bd8f91398679a839928b"
    end

    # name includes date to satisfy cache
    resource "cargo-nightly-2015-08-07" do
      url "https://static-rust-lang-org.s3.amazonaws.com/cargo-dist/2015-08-07/cargo-nightly-x86_64-apple-darwin.tar.gz"
      sha256 "d52c1e2d6290b9935ffdd2d079303e541cc995735a3f8fc4fa3e83857c384e78"
    end

    # name includes date to satisfy cache
    resource "rustc-nightly-2015-08-07" do
      url "https://static-rust-lang-org.s3.amazonaws.com/dist/2015-08-07/rustc-nightly-x86_64-apple-darwin.tar.gz"
      sha256 "18ee0e3ce5d6696f913a5f030d8dc2a5b0b9e81b0d0203da3c609a16eaeb3831"
    end
  end

  head do
    url "https://github.com/rust-lang/rust.git"
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git"
    end
  end

  bottle do
    sha256 "846bd0df87e414ecd4301659d1ad1e4491fba7cc44c78cf1e9c1874ecf24f808" => :yosemite
    sha256 "e78574a971f0111c7011c603a56cc97cea0e1980e19c95a9a10015c423f85f28" => :mavericks
    sha256 "f56191dd3cf36717649184111f4d8a4a9ddcefe7d12706f67cd3151ca1cfe6be" => :mountain_lion
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
        resource("rustc-nightly-2015-08-07").stage do
          system "./install.sh", "--prefix=#{cargo_stage_path}/rustc"
        end

        resource("cargo-nightly-2015-08-07").stage do
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
