class Dmd < Formula
  desc "D programming language compiler for OS X"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/D-Programming-Language/dmd/archive/v2.070.1.tar.gz"
    sha256 "a84c64bc46582fa5f010b1ec3daa7c48d54cc70dbc921df7834b44bfd41fd75c"

    resource "druntime" do
      url "https://github.com/D-Programming-Language/druntime/archive/v2.070.1.tar.gz"
      sha256 "4c37ede418443f64c84f94b3384fb908acc06410d477392fca3083c75052c031"
    end

    resource "phobos" do
      url "https://github.com/D-Programming-Language/phobos/archive/v2.070.1.tar.gz"
      sha256 "a755d75ed4cc008ea32eeb45c9cb78a9c21054384ed085d1c3b243a4e473482d"
    end

    resource "tools" do
      url "https://github.com/D-Programming-Language/tools/archive/v2.070.1.tar.gz"
      sha256 "ccab0941487b0d5589d3c87ecccf42623f361f47e922c5f5bb552a549a90804b"
    end
  end

  bottle do
    sha256 "28945c524db59ec04d43eb39d65e754e52c5dc78e9001fb2d810160bf4bf1274" => :el_capitan
    sha256 "681c51f57ec912e0831420ca7c31586e5de92c5cec6bef8e90cc860586ace73f" => :yosemite
    sha256 "c685a2c946fee33a41b59a01244b2cd44f690929a4987a950eeb3c9a6b4fee7a" => :mavericks
  end

  head do
    url "https://github.com/D-Programming-Language/dmd.git"

    resource "druntime" do
      url "https://github.com/D-Programming-Language/druntime.git"
    end

    resource "phobos" do
      url "https://github.com/D-Programming-Language/phobos.git"
    end

    resource "tools" do
      url "https://github.com/D-Programming-Language/tools.git"
    end
  end

  def install
    make_args = ["INSTALL_DIR=#{prefix}", "MODEL=#{Hardware::CPU.bits}", "-f", "posix.mak"]

    system "make", "SYSCONFDIR=#{etc}", "TARGET_CPU=X86", "AUTO_BOOTSTRAP=1", "RELEASE=1", *make_args

    bin.install "src/dmd"
    prefix.install "samples"
    man.install Dir["docs/man/*"]

    # A proper dmd.conf is required for later build steps:
    conf = buildpath/"dmd.conf"
    # Can't use opt_include or opt_lib here because dmd won't have been
    # linked into opt by the time this build runs:
    conf.write <<-EOS.undent
        [Environment]
        DFLAGS=-I#{include}/dlang/dmd -L-L#{lib}
        EOS
    etc.install conf
    install_new_dmd_conf

    make_args.unshift "DMD=#{bin}/dmd"

    (buildpath/"druntime").install resource("druntime")
    (buildpath/"phobos").install resource("phobos")

    system "make", "-C", "druntime", *make_args
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]

    resource("tools").stage do
      inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
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
