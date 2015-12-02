class Dmd < Formula
  desc "D programming language compiler for OS X"
  homepage "http://dlang.org"

  stable do
    url "https://github.com/D-Programming-Language/dmd/archive/v2.069.1.tar.gz"
    sha256 "abf63eeae164560d4d2cd4b61d8b8f2444925376e02245bce1fd28baf4c1f252"

    resource "druntime" do
      url "https://github.com/D-Programming-Language/druntime/archive/v2.069.1.tar.gz"
      sha256 "5d1fb286b2f3a032e8f4b1701ae6d787189701644b4e2b9b89e9b9a67f55439a"
    end

    resource "phobos" do
      url "https://github.com/D-Programming-Language/phobos/archive/v2.069.1.tar.gz"
      sha256 "737b4a630bb1734a34d4f61a145b99de022761edb3a92366ac777f8ccab87dc4"
    end

    resource "tools" do
      url "https://github.com/D-Programming-Language/tools/archive/v2.069.1.tar.gz"
      sha256 "5d0ee39e3f4e51ec9dbb7200249494f28846a3128a38d335260eb157b3bcfa68"
    end
  end

  bottle do
    sha256 "0f79eadd2e9318222a561d67c66b4cf488bc33e67c4c9ac4c31c714bd9f2f46d" => :el_capitan
    sha256 "9bd4b66fc5df16e665df31bfa61b15fbfb6ca10bbd6669553019c53ef7bd3d4b" => :yosemite
    sha256 "73bcca9b4c6456725e3064b405043f586a91c9e32047259bfec41105635477e9" => :mavericks
  end

  devel do
    url "https://github.com/D-Programming-Language/dmd/archive/v2.069.2-b1.tar.gz"
    sha256 "7514dd927557e7296831f07d9693ef13ddf80bf061f2903a573852d559b4a801"
    version "2.069.2-b1"

    resource "druntime" do
      url "https://github.com/D-Programming-Language/druntime/archive/v2.069.2-b1.tar.gz"
      sha256 "c63c79cdfd2ce115b8fba9e215cf6ad0e857a31dc6a56207368d159a23dd2070"
    end

    resource "phobos" do
      url "https://github.com/D-Programming-Language/phobos/archive/v2.069.2-b1.tar.gz"
      sha256 "cebb13d294542877f94324372f55e4d1db3b03621507c6f1f4d5cf00f90a495c"
    end

    resource "tools" do
      url "https://github.com/D-Programming-Language/tools/archive/v2.069.2-b1.tar.gz"
      sha256 "88d1b9964527430fb7787331ef975c9fe70b9acc256bc9231658aa574a5384a4"
    end
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
