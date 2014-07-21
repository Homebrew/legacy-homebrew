require "formula"

class Nss < Formula
  homepage "https://developer.mozilla.org/docs/NSS"
  url "https://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_16_2_RTM/src/nss-3.16.2.tar.gz"
  sha1 "c4e7f007723cfafcf7fe743000e3960cc5086642"

  bottle do
    cellar :any
    sha1 "614b281c05b0544ebf2485f2fdf25497136c6535" => :mavericks
    sha1 "e3db185142fff3fd11432d3542d59b722d02d06e" => :mountain_lion
    sha1 "65416dfa06130a4834c7a83e41dfb11a672c88e5" => :lion
  end

  depends_on "nspr"

  def install
    ENV.deparallelize
    cd "nss"

    args = [
      "BUILD_OPT=1",
      "NSS_USE_SYSTEM_SQLITE=1",
      "NSPR_INCLUDE_DIR=#{HOMEBREW_PREFIX}/include/nspr",
      "NSPR_LIB_DIR=#{HOMEBREW_PREFIX}/lib"
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

    (lib+"pkgconfig/nss.pc").write pc_file
  end

  test do
    # See: http://www.mozilla.org/projects/security/pki/nss/tools/certutil.html
    (testpath/"passwd").write("It's a secret to everyone.")
    system "#{bin}/certutil", "-N", "-d", pwd, "-f", "passwd"
    system "#{bin}/certutil", "-L", "-d", pwd
  end

  def pc_file; <<-EOS.undent
    prefix=#{opt_prefix}
    exec_prefix=${prefix}
    libdir=${exec_prefix}/lib
    includedir=${prefix}/include/nss

    Name: NSS
    Description: Mozilla Network Security Services
    Version: #{version}
    Requires: nspr
    Libs: -L${libdir} -lnss3 -lnssutil3 -lsmime3 -lssl3
    Cflags: -I${includedir}
    EOS
  end
end
