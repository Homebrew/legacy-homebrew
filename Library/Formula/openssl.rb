class Openssl < Formula
  homepage "https://openssl.org"
  url "https://www.openssl.org/source/openssl-1.0.2a.tar.gz"
  mirror "https://raw.githubusercontent.com/DomT4/LibreMirror/master/OpenSSL/openssl-1.0.2a.tar.gz"
  sha256 "15b6393c20030aab02c8e2fe0243cb1d1d18062f6c095d67bca91871dc7f324a"
  # Work around this being parsed as an alpha version by our
  # version detection code.
  version "1.0.2a-1"

  bottle do
    sha256 "61547bc1716db058c4e5a99e91067783031e8d47acfea9a8742e9899b363b463" => :yosemite
    sha256 "bff2a6db8e56255c85a49ccbad6cc8611bc47d1482ba630c632c6f9ca7cd7f35" => :mavericks
    sha256 "1e985e8bfb5f3c3041c6e022561aa137643895b7bd920654c85197268aed3637" => :mountain_lion
  end

  option :universal
  option "without-check", "Skip build-time tests (not recommended)"

  depends_on "makedepend" => :build

  keg_only :provided_by_osx,
    "Apple has deprecated use of OpenSSL in favor of its own TLS and crypto libraries"

  # This is a workaround for Apple removing the Equifax Secure CA root from the System in 10.10.3
  # Their doing so has broken certificate verification and consquently secure connection for dependants.
  # Scope this to Yosemite and remove immediately once Apple have fixed the issue.
  resource "Equifax_CA" do
    url "https://www.geotrust.com/resources/root_certificates/certificates/Equifax_Secure_Certificate_Authority.pem"
    sha256 "f24e19fb93983b4fd0a377335613305f330c699892c789356eb216449804d0e9"
  end

  def arch_args
    {
      :x86_64 => %w[darwin64-x86_64-cc enable-ec_nistp_64_gcc_128],
      :i386   => %w[darwin-i386-cc],
    }
  end

  def configure_args; %W[
      --prefix=#{prefix}
      --openssldir=#{openssldir}
      no-ssl2
      zlib-dynamic
      shared
      enable-cms
    ]
  end

  def install
    if build.universal?
      ENV.permit_arch_flags
      archs = Hardware::CPU.universal_archs
    elsif MacOS.prefer_64_bit?
      archs = [Hardware::CPU.arch_64_bit]
    else
      archs = [Hardware::CPU.arch_32_bit]
    end

    dirs = []

    archs.each do |arch|
      if build.universal?
        dir = "build-#{arch}"
        dirs << dir
        mkdir dir
        mkdir "#{dir}/engines"
        system "make", "clean"
      end

      ENV.deparallelize
      system "perl", "./Configure", *(configure_args + arch_args[arch])
      system "make", "depend"
      system "make"

      if (MacOS.prefer_64_bit? || arch == MacOS.preferred_arch) && build.with?("check")
        system "make", "test"
      end

      if build.universal?
        cp Dir["*.?.?.?.dylib", "*.a", "apps/openssl"], dir
        cp Dir["engines/**/*.dylib"], "#{dir}/engines"
      end
    end

    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"

    if build.universal?
      %w[libcrypto libssl].each do |libname|
        system "lipo", "-create", "#{dirs.first}/#{libname}.1.0.0.dylib",
                                  "#{dirs.last}/#{libname}.1.0.0.dylib",
                       "-output", "#{lib}/#{libname}.1.0.0.dylib"
        system "lipo", "-create", "#{dirs.first}/#{libname}.a",
                                  "#{dirs.last}/#{libname}.a",
                       "-output", "#{lib}/#{libname}.a"
      end

      Dir.glob("#{dirs.first}/engines/*.dylib") do |engine|
        libname = File.basename(engine)
        system "lipo", "-create", "#{dirs.first}/engines/#{libname}",
                                  "#{dirs.last}/engines/#{libname}",
                       "-output", "#{lib}/engines/#{libname}"
      end

      system "lipo", "-create", "#{dirs.first}/openssl",
                                "#{dirs.last}/openssl",
                     "-output", "#{bin}/openssl"
    end
  end

  def openssldir
    etc/"openssl"
  end

  def post_install
    keychains = %w[
      /Library/Keychains/System.keychain
      /System/Library/Keychains/SystemRootCertificates.keychain
    ]

    openssldir.mkpath
    (openssldir/"cert.pem").atomic_write `security find-certificate -a -p #{keychains.join(" ")}`

    if MacOS.version == :yosemite
      (openssldir/"certs").install resource("Equifax_CA")
      system bin/"c_rehash"
    end
  end

  def caveats; <<-EOS.undent
    A CA file has been bootstrapped using certificates from the system
    keychain. To add additional certificates, place .pem files in
      #{openssldir}/certs

    and run
      #{opt_bin}/c_rehash
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert (HOMEBREW_PREFIX/"etc/openssl/openssl.cnf").exist?,
            "OpenSSL requires the .cnf file for some functionality"

    # Check OpenSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "91b7b0b1e27bfbf7bc646946f35fa972c47c2d32"
    system "#{bin}/openssl", "dgst", "-sha1", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
