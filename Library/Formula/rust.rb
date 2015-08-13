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
