class Dmd < Formula
  desc "D programming language compiler for OS X"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/D-Programming-Language/dmd/archive/v2.069.2.tar.gz"
    sha256 "61159da964eb826d9e2d9fd8ca8efbbfbf10671734f3b1934874d11c5757ddac"

    resource "druntime" do
      url "https://github.com/D-Programming-Language/druntime/archive/v2.069.2.tar.gz"
      sha256 "469c5373f7368beead5df2d8cab49805b5faf1aa7fd639fc8df7a68572728db3"
    end

    resource "phobos" do
      url "https://github.com/D-Programming-Language/phobos/archive/v2.069.2.tar.gz"
      sha256 "241e426282a17c2e350701f38d87bd4ad675bfad1d3e92d9678a4578efed4fa0"
    end

    resource "tools" do
      url "https://github.com/D-Programming-Language/tools/archive/v2.069.2.tar.gz"
      sha256 "fc885b857f059e2992e317ecdd0d57ec284ce71fb7ddb89b65cb37cc9a1b492e"
    end
  end

  bottle do
    sha256 "35112e84d8e6f4ddb7635772b54e4f362f2ba780e7e95e27b1982660f822cb15" => :el_capitan
    sha256 "2a6a9f32fb66c94e481f211fa7474838b84c020326453fb294075d2748c02453" => :yosemite
    sha256 "10e5b4e9acb6884debf1cd8e16ddc4f7cf78643d293749d3327d867335c006c5" => :mavericks
  end

  devel do
    url "https://github.com/D-Programming-Language/dmd/archive/v2.070.0-b2.tar.gz"
    sha256 "df911a699e2ee705f3afdbabb023f0bb78df50335a822bc0a2b5d145bb995b10"
    version "2.070.0-b2"

    resource "druntime" do
      url "https://github.com/D-Programming-Language/druntime/archive/v2.070.0-b2.tar.gz"
      sha256 "3c4c1251cea9d51889cfe4da8dae035a5e36db1f2e419d7753fd44b92fa51af0"
    end

    resource "phobos" do
      url "https://github.com/D-Programming-Language/phobos/archive/v2.070.0-b2.tar.gz"
      sha256 "1b89b3fc272088f446673e795728258ee291ddc76a7b73525d3a325585624fb9"
    end

    resource "tools" do
      url "https://github.com/D-Programming-Language/tools/archive/v2.070.0-b2.tar.gz"
      sha256 "2917a1d7ef183279ecdcddbfb5c4543ecb36a860fe5ee9807a37ae3e6be58022"
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
