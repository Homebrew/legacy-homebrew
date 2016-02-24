class Dmd < Formula
  desc "D programming language compiler for OS X"
  homepage "https://dlang.org/"
  revision 1

  stable do
    url "https://github.com/D-Programming-Language/dmd/archive/v2.070.0.tar.gz"
    sha256 "22f47168af3f4106668f816c0e7a99b8db364fbe5324a5e763a209b9e74c0ee8"

    resource "druntime" do
      url "https://github.com/D-Programming-Language/druntime/archive/v2.070.0.tar.gz"
      sha256 "7ef1290d8482af5eb9d9744ca133488a3320db2a657bc5a9fdff846f56ba53f3"
    end

    resource "phobos" do
      url "https://github.com/D-Programming-Language/phobos/archive/v2.070.0.tar.gz"
      sha256 "b5cb9559b01e713ac1dd282648710d4a78f8228da778b4508a7b302877b82b6c"
    end

    resource "tools" do
      url "https://github.com/D-Programming-Language/tools/archive/v2.070.0.tar.gz"
      sha256 "a2864c8b440fec843d80f70e13ab8e7873f370d5bcca56fe272d94e3ba9afb77"
    end
  end

  bottle do
    sha256 "ee1163af3c5090e2e397a80bf97d5360b1a9da061690632124336b0a986cff32" => :el_capitan
    sha256 "355a7466679114275ff57cea14aba902f2a947653c883f177e61efa093b38694" => :yosemite
    sha256 "963c68712d2fbdb1b1e6ef67ead28cc44a4949dd660a1e121c2c20efcdc7c1ca" => :mavericks
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
