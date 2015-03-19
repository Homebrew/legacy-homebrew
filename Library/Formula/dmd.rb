require "formula"

class Dmd < Formula
  homepage "http://dlang.org"
  url "https://github.com/D-Programming-Language/dmd/archive/v2.066.1.tar.gz"
  sha1 "7be9737f97a494870446c881e185bec41f337792"

  bottle do
    revision 1
    sha256 "c19e75d44f1e184aa8b65e276de498be33a80e088ab93145bfcff07a08d1a78e" => :yosemite
    sha256 "f41633629f7767e61f7d968c762c58f11bbdb5308bfe59d6d05c7249aa00797b" => :mavericks
    sha256 "b8c380eae74b0092134095ad48628392cc7715a3c75feb942bfac027549d3123" => :mountain_lion
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

    # A proper dmd.conf is required for later build steps:
    conf = buildpath/"dmd.conf"
    # Can't use opt_include or opt_lib here because dmd won't have been
    # linked into opt by the time this build runs:
    conf.write <<-EOS.undent
        [Environment]
        DFLAGS=-I#{include}/d2 -L-L#{lib}
        EOS
    etc.install conf
    install_new_dmd_conf

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

  # Previous versions of this formula may have left in place an incorrect
  # dmd.conf.  If it differs from the newly generated one, move it out of place
  # and warn the user.
  # This must be idempotent because it may run from both install() and
  # post_install() if the user is running `brew install --build-from-source`.
  def install_new_dmd_conf
    conf = etc/"dmd.conf"

    # If the new file differs from conf, etc.install drops it here:
    new_conf = etc/"dmd.conf.default"
    # Else, we're already using the latest version:
    return unless new_conf.exist?

    backup = etc/"dmd.conf.old"
    opoo "An old dmd.conf was found and will be moved to #{backup}."
    mv conf, backup
    mv new_conf, conf
  end

  def post_install
    install_new_dmd_conf
  end

  test do
    system bin/"dmd", prefix/"samples/hello.d"
    system "./hello"
  end
end
