require 'formula'

class Nss < Formula
  homepage 'http://www.mozilla.org/projects/security/pki/nss/'
  url 'http://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_14_1_RTM/src/nss-3.14.1.tar.gz'
  sha1 '764773e869aaee314e6f3ca675e04c55075d88a8'

  depends_on 'nspr'

  keg_only 'NSS installs a libssl which conflicts with OpenSSL.'

  def install
    ENV.deparallelize

    args = [
      'BUILD_OPT=1',
      'NSS_ENABLE_ECC=1',
      'NS_USE_GCC=1',
      'NO_MDUPDATE=1',
      'NSS_USE_SYSTEM_SQLITE=1',
      "NSPR_INCLUDE_DIR=#{HOMEBREW_PREFIX}/include/nspr",
      "NSPR_LIB_DIR=#{HOMEBREW_PREFIX}/lib"
    ]
    args << 'USE_64=1' if MacOS.prefer_64_bit?

    # Remove the broken (for anyone but Firefox) install_name
    inreplace "mozilla/security/coreconf/Darwin.mk", "-install_name @executable_path", "-install_name #{lib}"
    inreplace "mozilla/security/nss/lib/freebl/config.mk", "@executable_path", lib

    system "make", "build_coreconf", "build_dbm", "all", "-C", "mozilla/security/nss", *args

    # We need to use cp here because all files get cross-linked into the dist
    # hierarchy, and Homebrew's Pathname.install moves the symlink into the keg
    # rather than copying the referenced file.

    bin.mkdir
    Dir['mozilla/dist/Darwin*/bin/*'].each do |file|
      cp file, bin
    end

    include.mkdir
    include_target = include + "nss"
    include_target.mkdir
    ['dbm', 'nss'].each do |dir|
      Dir["mozilla/dist/public/#{dir}/*"].each do |file|
        cp file, include_target
      end
    end

    lib.mkdir
    Dir['mozilla/dist/Darwin*/lib/*'].each do |file|
      cp file, lib
    end

    (lib+'pkgconfig/nss.pc').write pc_file
  end

  test do
    # See: http://www.mozilla.org/projects/security/pki/nss/tools/certutil.html
    File.open('passwd', 'w') {|f| f.write("It's a secret to everyone.") }
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
