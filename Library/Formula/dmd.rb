require "formula"

class Dmd < Formula
  homepage "http://dlang.org"
  url "https://github.com/D-Programming-Language/dmd/archive/v2.066.1.tar.gz"
  sha1 "7be9737f97a494870446c881e185bec41f337792"

  bottle do
    sha1 "6cb24133ba8e8973442d13b358dc14ea7f9d8c43" => :yosemite
    sha1 "19e104830f0e6dbb4a422fd141254af784268a4d" => :mavericks
    sha1 "c7c4f4b32f5e88c73f0efb8eb90d92a7956694e6" => :mountain_lion
  end

  resource "druntime" do
    url "https://github.com/D-Programming-Language/druntime/archive/v2.066.1.tar.gz"
    sha1 "614e2944c470944125ba6bc94a78c1cf0a41ad5a"
  end

  resource "phobos" do
    url "https://github.com/D-Programming-Language/phobos/archive/v2.066.1.tar.gz"
    sha1 "58e48b33cffbab4acb5e6d6f376ea209ce8e2114"
  end

  resource "tools" do
    url "https://github.com/D-Programming-Language/tools/archive/v2.066.1.tar.gz"
    sha1 "fc64b35364cf76d7270e4a8fe41203e0b4dde11c"
  end

  def install
    make_args = ["INSTALL_DIR=#{prefix}", "MODEL=#{Hardware::CPU.bits}", "-f", "posix.mak"]

    system "make", "SYSCONFDIR=#{etc}", "TARGET_CPU=X86", "RELEASE=1", *make_args

    bin.install "src/dmd"
    prefix.install "samples"
    man.install Dir["docs/man/*"]

    conf = etc/"dmd.conf"

    if conf.exist?
      inreplace conf, /^DFLAGS=.+$/, "DFLAGS=-I#{include}/d2 -L-L#{lib}"
    else
      conf.write <<-EOS.undent
        [Environment]
        DFLAGS=-I#{include}/d2 -L-L#{lib}
        EOS
    end

    make_args.unshift "DMD=#{bin}/dmd"

    (buildpath/"druntime").install resource("druntime")
    (buildpath/"phobos").install resource("phobos")

    system "make", "-C", "druntime", *make_args
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    (include/"d2").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"d2"
    lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]


    resource("tools").stage do
      inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS)"
      system "make", "install", *make_args
    end
  end

  test do
    system bin/"dmd", prefix/"samples/hello.d"
    system "./hello"
  end
end
