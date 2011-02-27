require 'formula'

class Nss <Formula
  version '3.12.9'
  url "http://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_12_9_RTM/src/nss-#{version}.tar.gz"
  homepage 'http://www.mozilla.org/projects/security/pki/nss/'
  md5 'bd32f183ca28440c1744650be31a9ccc'

  depends_on "sqlite"
  depends_on "nspr"

  def patches
    base = "http://trac.macports.org/export/75867/trunk/dports/net/nss/files"
    {
      :p0 => ["#{base}/patch-UNIX.mk.diff", "#{base}/patch-Darwin.mk.diff"]
    }
  end

  def install
    ENV.deparallelize
    Dir.chdir "mozilla/security" do
      inreplace ["coreconf/Darwin.mk", "coreconf/UNIX.mk", "nss/cmd/platlibs.mk",
                 "nss/lib/smime/config.mk", "nss/lib/ssl/config.mk"] do |s|
        s.gsub!('@executable_path', "#{lib}/nss")
        s.gsub!('@@PREFIX@@/lib/nspr', "#{HOMEBREW_PREFIX}/lib")
        s.gsub!('@@PREFIX@@/include/nspr', "#{HOMEBREW_PREFIX}/include/nspr")
        s.gsub!('@@PREFIX@@', "#{prefix}")
        s.gsub!('= cc\$', "= #{ENV.cc}")
        s.gsub!('= c++\$', "= #{ENV.cxx}")
        s.gsub!('= ranlib\$', "= /usr/bin/ranlib")
      end
    end

    args = ["NSPR_LIB_DIR=#{HOMEBREW_PREFIX}", "NSS_USE_SYSTEM_SQLITE=1"]
    args << "USE_64=1" if snow_leopard_64?
    args = args.join(' ')

    system "make -C mozilla/security/coreconf/nsinstall #{args}"
    system "make -C mozilla/security/dbm #{args}"
    system "make -C mozilla/security/nss #{args}"

    bin.mkdir
    lib.mkdir
    include.mkdir
    (include+"nss").mkdir

    # We want to prefix all binaries with "nss-"
    Dir["mozilla/dist/Darwin*/bin/*"].each do |file|
      cp file, "#{bin}/nss-" + File.basename(file)
    end

    Dir["mozilla/dist/public/nss/*"].each { |file| cp file, include+"nss" }
    Dir["mozilla/dist/public/dbm/*"].each { |file| cp file, include+"nss" }
    Dir["mozilla/dist/Darwin*/lib/*.dylib"].each { |file| cp file, lib }
    Dir["mozilla/dist/Darwin*/lib/libcrmf.a"].each { |file| cp file, lib }
  end
end
