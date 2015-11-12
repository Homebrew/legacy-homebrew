require "language/go"

class Wellington < Formula
  desc "Adds file awareness to SASS"
  homepage "https://github.com/wellington/wellington"

  stable do
    url "https://github.com/wellington/wellington/archive/v0.9.3.tar.gz"
    sha256 "108e5626dad9494a1de7d6241a2f96c6fa5bd774133a00c301d42abd1089f3e2"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1d2aed7822f39cd64bc6dc789f78b6f23e85fff0eedefc0b5950e41a5d567db6" => :el_capitan
    sha256 "9d3f392f5df514a09ee92652974b91d14f94f2e83aec0536a4abff61f4a3aa97" => :yosemite
    sha256 "44a40c37b072ddaed80efa4bcd4752ce85d8d73c70fdb8bb674997172d74cbf3" => :mavericks
  end

  devel do
    url "https://github.com/wellington/wellington/archive/v1.0.0-beta1.tar.gz"
    sha256 "6ea2a260ba7146a6bd87f42ab22082dfd84eb5aa52adae0629cbe71395cf56de"
    version "1.0.0-beta1"
  end

  needs :cxx11

  head do
    url "https://github.com/wellington/wellington.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep.git",
      :revision => "fe7138c011ae7875d4af21efe8b237f4987d8c4a"
  end

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git",
      :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "golang.org/x/tools" do
    url "https://github.com/golang/tools.git",
      :revision => "ea5101579e09ace53571c8a5bae6ebb896f8d5e4"
  end

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    version = File.read("version.txt").chomp
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/tools/godep" do
      system "go", "install"
    end
    system "bin/godep", "restore"

    # Build libsass from source for head build
    if build.head?
      ENV.cxx11
      ENV["PKG_CONFIG_PATH"] = buildpath/"src/github.com/wellington/go-libsass/lib/pkgconfig"

      ENV.append "CGO_LDFLAGS", "-stdlib=libc++" if ENV.compiler == :clang
      cd "src/github.com/wellington/go-libsass/" do
        system "make", "deps"
      end
    end

    # symlink into $GOPATH so builds work
    mkdir_p buildpath/"src/github.com/wellington"
    ln_s buildpath, buildpath/"src/github.com/wellington/wellington"

    system "go", "build", "-ldflags", "-X github.com/wellington/wellington/version.Version #{version}", "-o", "dist/wt", "wt/main.go"
    bin.install "dist/wt"
  end

  test do
    s = "div { p { color: red; } }"
    expected = <<-EOS.undent
      Reading from stdin, -h for help
      /* line 1, stdin */
      div p {
        color: red; }
    EOS
    assert_equal expected, pipe_output("#{bin}/wt", s, 0)
  end
end
