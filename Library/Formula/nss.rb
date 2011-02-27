require 'formula'

class Nss <Formula
  url "http://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_12_9_RTM/src/nss-3.12.9.tar.gz"
  homepage 'http://www.mozilla.org/projects/security/pki/nss/'
  md5 'bd32f183ca28440c1744650be31a9ccc'

  depends_on "nspr"

  def install
    # NSS build fails with parallel calls to make
    ENV.deparallelize

    # Apply patches with inreplace
    Dir.chdir "mozilla/security" do
      inreplace ["coreconf/Darwin.mk", "coreconf/UNIX.mk", "nss/cmd/platlibs.mk",
                 "nss/lib/smime/config.mk", "nss/lib/ssl/config.mk"] do |s|
        s.gsub!('@executable_path', "#{lib}/nss")
        s.gsub!('DEFINES    += -DDEBUG -UNDEBUG -DDEBUG_$(USERNAME)',
                "DEFINES    += -DDEBUG -UNDEBUG -DDEBUG_$(USERNAME) -I#{HOMEBREW_PREFIX}/include/nspr")
      end
    end

    args = ["NSPR_LIB_DIR=#{HOMEBREW_PREFIX}", "NSS_USE_SYSTEM_SQLITE=1"]
    args << "USE_64=1" if snow_leopard_64?
    args = args.join(' ')

    system "make -C mozilla/security/coreconf/nsinstall #{args}"
    system "make -C mozilla/security/dbm #{args}"
    system "make -C mozilla/security/nss #{args}"

    # We need to use system cp here as Mozilla cross-links all files into
    # the dist hierarchy and Homebrew's Pathname.install moves the symlink
    # into the keg rather than copying the referenced file.
    include.mkdir
    include_target = include + "nss"
    include_target.mkdir
    Dir["mozilla/dist/public/nss/*"].each { |file| cp file, include_target }
    Dir["mozilla/dist/public/dbm/*"].each { |file| cp file, include_target }

    lib.mkdir
    Dir["mozilla/dist/Darwin*/lib/*.dylib"].each { |file| cp file, lib }
    Dir["mozilla/dist/Darwin*/lib/libcrmf.a"].each { |file| cp file, lib }

    # We want to prefix all binaries with "nss-" to be sure that nothing
    # collides with other binaries. We also need to use cp here 
    bin.mkdir
    Dir["mozilla/dist/Darwin*/bin/*"].each do |file|
      cp file, "#{bin}/nss-" + File.basename(file)
    end
  end
end
