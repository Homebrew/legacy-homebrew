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
    revision 1
    sha256 "ad74977cb630c724291a1f6c1945267364cb0d2c95526edfc32c58b77de2f607" => :el_capitan
    sha256 "7fa8e1d98ae7c8828623148916c1377f61ac1df1ff3f6f5171d1d2525b79d229" => :yosemite
    sha256 "db9eaa47b5700fbaf482f1a332cb73ea8c1a099dee25ec41d06d2d70becc6fdb" => :mavericks
  end

  devel do
    url "https://github.com/D-Programming-Language/dmd/archive/v2.070.1-b1.tar.gz"
    sha256 "3e78dc04d75e54ba484bdd39510c0107157c2bb784b2d47de3fb918bb0f59752"
    version "2.070.1-b1"

    resource "druntime" do
      url "https://github.com/D-Programming-Language/druntime/archive/v2.070.1-b1.tar.gz"
      sha256 "9566ff34e3fedf66bf36dae1534107e05f527f4196f2165632f41d68717d925a"
    end

    resource "phobos" do
      url "https://github.com/D-Programming-Language/phobos/archive/v2.070.1-b1.tar.gz"
      sha256 "8f2006dbe1dbd2c45dce97a0bb5343552cee8a853d5279c19fb33ee79395c59d"
    end

    resource "tools" do
      url "https://github.com/D-Programming-Language/tools/archive/v2.070.1-b1.tar.gz"
      sha256 "7bbbac3a33f6bbc2f24e9746ff3f428f10f52180b4b50edc67ed9b4e5ee4b55c"
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
