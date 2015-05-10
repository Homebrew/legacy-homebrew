class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  version "1.0.0-beta.4"

  stable do
    url 'https://static.rust-lang.org/dist/rustc-1.0.0-beta.4-src.tar.gz'
    sha256 '54e5868dd55a5c171327c72d662b5931a962b0cf160022d11c189ea232e0bd91'

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", :revision => "83a6d0ed8208d31a1f6dab5e5183ad9eb2d65eaf", :tag => "0.2.0"
    end

    # name includes date to satisfy cache
    resource "cargo-nightly-2015-04-02" do
      url "https://static-rust-lang-org.s3.amazonaws.com/cargo-dist/2015-04-02/cargo-nightly-x86_64-apple-darwin.tar.gz"
      sha256 "18647dccb34acb6085a04b0ea1bfb9d150dc9c17f7829932ddf7e62d518df2fe"
    end

    # name includes date to satisfy cache
    resource "rustc-nightly-2015-04-04" do
      url "https://static-rust-lang-org.s3.amazonaws.com/dist/2015-04-04/rustc-nightly-x86_64-apple-darwin.tar.gz"
      sha256 "87068b325802fee65a388d249b98a184aff7670140133de78560ef375bae70a5"
    end
  end

  head do
    url "https://github.com/rust-lang/rust.git"
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git"
    end
  end

  bottle do
    sha256 "73085de73a7dbd23651b329795227418de50709f156ddaeef9bbc9dd4c45a1d5" => :yosemite
    sha256 "9742c4c83f10d6d4e800a3d62916acdf3470f95293ca7a213f929a7884c9698a" => :mavericks
    sha256 "fe27cbe874f1f2334c51483c084b367e14aee913dd351dabdf9a2c07a257cf7a" => :mountain_lion
  end

  depends_on "openssl"
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    args = ["--prefix=#{prefix}"]
    args << "--disable-rpath" if build.head?
    args << "--enable-clang" if ENV.compiler == :clang
    args << "--release-channel=beta" unless build.head?
    system "./configure", *args
    system "make"
    system "make install"

    resource("cargo").stage do
      cargo_stage_path = pwd

      if build.stable?
        resource("rustc-nightly-2015-04-04").stage do
          system "./install.sh", "--prefix=#{cargo_stage_path}/rustc"
        end

        resource("cargo-nightly-2015-04-02").stage do
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
