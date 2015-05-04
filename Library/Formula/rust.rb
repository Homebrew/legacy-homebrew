class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  version "1.0.0-beta.3"

  stable do
    url 'https://static.rust-lang.org/dist/rustc-1.0.0-beta.3-src.tar.gz'
    sha256 'e751bc8a8ad236c8865697f866b2863e224af56b0194ddf9f3edd71f9ff6545f'

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
    revision 1
    sha256 "ffa02664fa9b91120490e38dc50649139e0d467daffb0a3e91cf9536fbef3b61" => :yosemite
    sha256 "b6debba43db24f54a722c8cca4c2bb515d31564c5f78ec12dedcf3543dbe19cb" => :mavericks
    sha256 "5313948a4e21b5dabeb58b4c7ee5998a41878335bd98abfdea84615c2a427646" => :mountain_lion
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
