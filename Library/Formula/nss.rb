class Nss < Formula
  desc "Libraries for security-enabled client and server applications"
  homepage "https://developer.mozilla.org/docs/NSS"
  url "https://archive.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_20_1_RTM/src/nss-3.20.1.tar.gz"
  sha256 "ad3c8f11dfd9570c2d04a6140d5ef7c2bdd0fe30d6c9e5548721a4251a5e8c97"

  bottle do
    cellar :any
    sha256 "bce5caa3a0cf836a67b21570e1890c58cba188b6119522a4d455399e01c89620" => :el_capitan
    sha256 "8d1d946335844f94f242eebef9b1d315414cab1296156803637dc1584fcfcaf7" => :yosemite
    sha256 "af66e34283ee6d07dd7c4b8bcf8d987a3af2ee2dd75b816bd7935de31379af21" => :mavericks
  end

  keg_only <<-EOS.undent
    Having this library symlinked makes Firefox pick it up instead of built-in,
    so it then randomly crashes without meaningful explanation.

    Please see https://bugzilla.mozilla.org/show_bug.cgi?id=1142646 for details.
  EOS

  depends_on "nspr"

  def install
    ENV.deparallelize
    cd "nss"

    args = %W[
      BUILD_OPT=1
      NSS_USE_SYSTEM_SQLITE=1
      NSPR_INCLUDE_DIR=#{Formula["nspr"].opt_include}/nspr
      NSPR_LIB_DIR=#{Formula["nspr"].opt_lib}
    ]
    args << "USE_64=1" if MacOS.prefer_64_bit?

    # Remove the broken (for anyone but Firefox) install_name
    inreplace "coreconf/Darwin.mk", "-install_name @executable_path", "-install_name #{lib}"
    inreplace "lib/freebl/config.mk", "@executable_path", lib

    system "make", "all", *args

    # We need to use cp here because all files get cross-linked into the dist
    # hierarchy, and Homebrew's Pathname.install moves the symlink into the keg
    # rather than copying the referenced file.
    cd "../dist"
    bin.mkpath
    Dir.glob("Darwin*/bin/*") do |file|
      cp file, bin unless file.include? ".dylib"
    end

    include_target = include + "nss"
    include_target.mkpath
    Dir.glob("public/{dbm,nss}/*") { |file| cp file, include_target }

    lib.mkpath
    libexec.mkpath
    Dir.glob("Darwin*/lib/*") do |file|
      if file.include? ".chk"
        cp file, libexec
      else
        cp file, lib
      end
    end
    # resolves conflict with openssl, see #28258
    rm lib/"libssl.a"

    (bin/"nss-config").write config_file
    (lib/"pkgconfig/nss.pc").write pc_file
  end

  test do
    # See: https://developer.mozilla.org/docs/Mozilla/Projects/NSS/tools/NSS_Tools_certutil
    (testpath/"passwd").write("It's a secret to everyone.")
    system "#{bin}/certutil", "-N", "-d", pwd, "-f", "passwd"
    system "#{bin}/certutil", "-L", "-d", pwd
  end

  # A very minimal nss-config for configuring firefox etc. with this nss,
  # see https://bugzil.la/530672 for the progress of upstream inclusion.
  def config_file; <<-EOS.undent
    #!/bin/sh
    for opt; do :; done
    case "$opt" in
      --version) opt="--modversion";;
      --cflags|--libs) ;;
      *) exit 1;;
    esac
    pkg-config "$opt" nss
    EOS
  end

  def pc_file; <<-EOS.undent
    prefix=#{prefix}
    exec_prefix=${prefix}
    libdir=${exec_prefix}/lib
    includedir=${prefix}/include/nss

    Name: NSS
    Description: Mozilla Network Security Services
    Version: #{version}
    Requires: nspr >= 4.10.10
    Libs: -L${libdir} -lnss3 -lnssutil3 -lsmime3 -lssl3
    Cflags: -I${includedir}
    EOS
  end
end
