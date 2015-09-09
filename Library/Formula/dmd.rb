class Dmd < Formula
  desc "D programming language compiler for OS X"
  homepage "http://dlang.org"

  stable do
    url "https://github.com/D-Programming-Language/dmd/archive/v2.068.1.tar.gz"
    sha256 "8f2865d480392aa821b5a028956d92a52400dc73d17b23c12d06d136100324ad"

    resource "druntime" do
      url "https://github.com/D-Programming-Language/druntime/archive/v2.068.1.tar.gz"
      sha256 "3730b763717e3eb08c19c207bc23162b8b9fe7368d70a3bb8498a26e0377eb18"
    end

    resource "phobos" do
      url "https://github.com/D-Programming-Language/phobos/archive/v2.068.1.tar.gz"
      sha256 "5326f509e42193ad56cb5fdbde26ec403fd1f1eac559fbc56f957a7f9bd14c8a"
    end

    resource "tools" do
      url "https://github.com/D-Programming-Language/tools/archive/v2.068.1.tar.gz"
      sha256 "a0b4362291949f1e88e32d89280860c08dfd00f34a235ebe276c8555b9862f4c"
    end
  end

  bottle do
    sha256 "d9dd3d6e8439ce0a297d145fcbf582abd49dd7dc4b71cdb888c7f5da010f90f3" => :yosemite
    sha256 "6d624bc4ac38aebc3f03e719b814c3918c07afb1368e0af82b1741e881b2f8dc" => :mavericks
    sha256 "2bf625841942b8af940ba2b735b802823ed538da6a2b8a1be0351241d7e70280" => :mountain_lion
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
