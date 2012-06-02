require 'formula'

class Nss < Formula
  url 'http://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_12_10_RTM/src/nss-3.12.10.tar.gz'
  homepage 'http://www.mozilla.org/projects/security/pki/nss/'
  md5 '027954e894f02732f4e66cd854261145'

  depends_on 'nspr'

  def install
    ENV.deparallelize

    args = [
      'BUILD_OPT=1',
      'NSS_ENABLE_ECC=1',
      'NS_USE_GCC=1',
      'NO_MDUPDATE=1',
      'NSS_USE_SYSTEM_SQLITE=1',
      "NSPR_INCLUDE_DIR=#{HOMEBREW_PREFIX}/include/nspr"
    ]
    args << 'USE_64=1' if MacOS.prefer_64_bit?

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

    (lib+'pkgconfig/nss.pc').write pkg_file
  end

  def test
    # See: http://www.mozilla.org/projects/security/pki/nss/tools/certutil.html
    mktemp do
      File.open('passwd', 'w') {|f| f.write("It's a secret to everyone.") }
      system "#{bin}/certutil", "-N", "-d", pwd, "-f", "passwd"
      system "#{bin}/certutil", "-L", "-d", pwd
    end
  end

  def pkg_file; <<-EOF
prefix=#{HOMEBREW_PREFIX}
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include/nss

Name: NSS
Description: Mozilla Network Security Services
Version: 3.12.10
Requires: nspr
Libs: -L${libdir} -lnss3 -lnssutil3 -lsmime3 -lssl3
Cflags: -I${includedir}
EOF
  end
end
