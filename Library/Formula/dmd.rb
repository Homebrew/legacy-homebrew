require "formula"

class Dmd < Formula
  homepage "http://dlang.org"
  url "https://github.com/D-Programming-Language/dmd/archive/v2.066.0.tar.gz"
  sha1 "4ad09f680b249bb10b014b61ccb791a24f7a84c6"

  bottle do
    sha1 "1cbca6f4f1b0d2af27ad6571c0b2f4b37b928423" => :mavericks
    sha1 "a61c224f5d15c7b846b3348e196dde6a86cf6b0a" => :mountain_lion
    sha1 "051c88ee54bebc15c3908fd2f31ec18b6634b9c1" => :lion
  end

  resource "druntime" do
    url "https://github.com/D-Programming-Language/druntime/archive/v2.066.0.tar.gz"
    sha1 "e1a5a29898127b4775a7b60c2534c3f4fc4387a9"
  end

  resource "phobos" do
    url "https://github.com/D-Programming-Language/phobos/archive/v2.066.0.tar.gz"
    sha1 "92385871df5883034055a20f8e8da5c398d11dd6"
  end

  resource "tools" do
    url "https://github.com/D-Programming-Language/tools/archive/v2.066.0.tar.gz"
    sha1 "03384e9237c778e9afcecd10e756111fd4f323de"
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
