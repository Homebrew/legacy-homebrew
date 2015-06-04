require "formula"

class Nss < Formula
  homepage "https://developer.mozilla.org/docs/NSS"
  url "https://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_19_1_RTM/src/nss-3.19.1.tar.gz"
  sha256 "b7be709551ec13206d8e3e8c065b894fa981c11573115e9478fa051029c52fff"

  bottle do
    cellar :any
    sha256 "3b4771ff0a8079b58d6a37775329fe2654451f1b510b02e2aafe52efea14b898" => :yosemite
    sha256 "e76c397688606b966a5ff1bb1e10fb98575fe7ce53589c2756c8b394980bcbe2" => :mavericks
    sha256 "17a5921677457552c0ece0c6c3bcfb8d5fee28ebf0b7a1207ffc03682a902b1a" => :mountain_lion
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

    args = [
      "BUILD_OPT=1",
      "NSS_USE_SYSTEM_SQLITE=1",
      "NSPR_INCLUDE_DIR=#{Formula["nspr"].opt_include}/nspr",
      "NSPR_LIB_DIR=#{Formula["nspr"].opt_lib}"
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

    (bin+"nss-config").write config_file
    (lib+"pkgconfig/nss.pc").write pc_file
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
    Requires: nspr >= 4.10.8
    Libs: -L${libdir} -lnss3 -lnssutil3 -lsmime3 -lssl3
    Cflags: -I${includedir}
    EOS
  end
end
