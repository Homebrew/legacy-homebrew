class Dmd < Formula
  desc "D programming language compiler for OS X"
  homepage "http://dlang.org"

  stable do
    url "https://github.com/D-Programming-Language/dmd/archive/v2.069.0.tar.gz"
    sha256 "a75621e2584bbde8b10eefd58fdafa74adf4df8d35abdc9bb68dd00fbc1a4787"

    resource "druntime" do
      url "https://github.com/D-Programming-Language/druntime/archive/v2.069.0.tar.gz"
      sha256 "84b359e7160a797cf4f21dda0b39e18256d12f68e16ad4348214f0d8785dffc8"
    end

    resource "phobos" do
      url "https://github.com/D-Programming-Language/phobos/archive/v2.069.0.tar.gz"
      sha256 "81b391dc943e8069217cda765bf015c29a2dcf70267c6e7bf4f845d67229b11a"
    end

    resource "tools" do
      url "https://github.com/D-Programming-Language/tools/archive/v2.069.0.tar.gz"
      sha256 "6219306fcb51b5f69fabd241d1e78cb67f953589c6f0d10a627d2025e455ddff"
    end
  end

  bottle do
    sha256 "578203e347dffa72549d9edd2651f15bfa64de8d555a59f89cc83fb1d6bc51b6" => :el_capitan
    sha256 "ad2908bb8822c1b3145009b158a95b825705f60da3a828c8bb221ca8a25538a9" => :yosemite
    sha256 "9dbc01cf2450007bc85d965c43f795fd0504a8d195c13fa9789d567e4cd84cf3" => :mavericks
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
