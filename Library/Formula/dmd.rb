require "formula"

class Dmd < Formula
  desc "D programming language compiler for OS X"
  homepage "http://dlang.org"
  url "https://github.com/D-Programming-Language/dmd/archive/v2.067.1.tar.gz"
  sha1 "05eed2bcd850cd5be88e7f20f31d19f10b17dc5d"

  bottle do
    sha256 "b8275d7fc008a679c964f65bae94ef4bfc49b0df5ad06b6ba209666cc102af04" => :yosemite
    sha256 "2a622f2cfaf3b2c3d877263a3799ac30b3faf25bffbf65a4694f2ee63c073916" => :mavericks
    sha256 "cc6270157c3507acb81dcb60ff4447aedc24077a22995d1e5ec08c3edd0d9a96" => :mountain_lion
  end

  resource "druntime" do
    url "https://github.com/D-Programming-Language/druntime/archive/v2.067.1.tar.gz"
    sha1 "c0664530ad1e38d4535f2d4df1ba733dff44785e"
  end

  resource "phobos" do
    url "https://github.com/D-Programming-Language/phobos/archive/v2.067.1.tar.gz"
    sha1 "5cc3fe9a33bee926a605a1308dbdc48f3a71a899"
  end

  resource "tools" do
    url "https://github.com/D-Programming-Language/tools/archive/v2.067.1.tar.gz"
    sha1 "00c2442ffaa1001870aa37c73e94ec3b50266c6f"
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
