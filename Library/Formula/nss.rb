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
      "USE_64=#{MacOS.prefer_64_bit? ? 1 : 0}",
      'NO_MDUPDATE=1',
      'NSS_USE_SYSTEM_SQLITE=1',
      "NSPR_INCLUDE_DIR=#{HOMEBREW_PREFIX}/include/nspr"
    ].join(' ')

    system "make build_coreconf build_dbm all -C mozilla/security/nss #{args}"

    # We need to use cp here because all files get cross-linked into the dist
    # hierarchy, and Homebrew's Pathname.install moves the symlink into the keg
    # rather than copying the referenced file.

    bin.mkdir
    Dir['mozilla/dist/Darwin*/bin/*'].each do |file|
      # Add 'nss-' prefix to prevent collisions with other binaries.
      cp file, "#{bin}/nss-" + File.basename(file)
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
  end

  def test
    # http://www.mozilla.org/projects/security/pki/nss/tools/certutil.html
    certdir  = '/tmp/nss-test'
    pwfile   = "#{certdir}/passwd"
    password = "It's a secret to everyone."

    Dir.mkdir(certdir) unless File.directory?(certdir)
    File.open(pwfile, 'w') {|f| f.write(password) }
    system "nss-certutil -N -d #{certdir} -f #{pwfile}"
    system "nss-certutil -L -d #{certdir}"
    system "rm #{certdir}/*"
  end
end
