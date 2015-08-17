class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.2.0-src.tar.gz"
    sha256 "ea6eb983daf2a073df57186a58f0d4ce0e85c711bec13c627a8c85d51b6a6d78"

    resource "cargo" do
      # git required because of submodules
      url "https://github.com/rust-lang/cargo.git", :tag => "0.4.0", :revision => "553b363bcfcf444c5bd4713e30382a6ffa2a52dd"
    end

    # name includes date to satisfy cache
    resource "cargo-nightly-2015-08-12" do
      url "https://static-rust-lang-org.s3.amazonaws.com/cargo-dist/2015-08-12/cargo-nightly-x86_64-apple-darwin.tar.gz"
      sha256 "3d0ea9e20215e6450e2ae3977bbe20b9fb2bbf51ce145017ab198ea3409ffda2"
    end
  end

  head do
    url "https://github.com/rust-lang/rust.git"
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git"
    end
  end

  bottle do
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
        resource("cargo-nightly-2015-08-12").stage do
          system "./install.sh", "--prefix=#{cargo_stage_path}/target/snapshot/cargo"
          # satisfy make target to skip download
          touch "#{cargo_stage_path}/target/snapshot/cargo/bin/cargo"
        end
      end

      # Fix for El Capitan DYLD_LIBRARY_PATH behavior
      # https://github.com/rust-lang/cargo/issues/1816
      inreplace "Makefile.in" do |s|
        s.gsub! '"$$(CFG_RUSTC)"', '$$(CFG_RUSTC)'
        s.gsub! '"$$(CARGO)"', '$$(CARGO)'
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
