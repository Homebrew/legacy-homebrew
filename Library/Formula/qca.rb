require "formula"

class Qca < Formula
  homepage "http://delta.affinix.com/qca/"
  url "http://delta.affinix.com/download/qca/2.0/qca-2.1.0.tar.gz"
  sha1 "2b582b3ccc7e6098cd14d6f52a829ae1539e9cc8"

  head "git://anongit.kde.org/qca.git", :branch => "master"

  option "with-api-docs", "Build API documentation"
  option "with-tests", "Don't build and run tests"

  depends_on "cmake" => :build
  depends_on "qt" => :recommended
  depends_on "qt5" => :optional

  # Plugins (QCA needs at least one plugin to do anything useful)
  depends_on "openssl" # qca-ossl
  depends_on "botan" => :optional # qca-botan
  depends_on "libgcrypt" => :optional # qca-gcrypt
  depends_on "gnupg" => :optional # qca-gnupg
  depends_on "nss" => :optional # qca-nss
  depends_on "pkcs11-helper" => :optional # qca-pkcs11

  if build.with? "api-docs"
    depends_on "graphviz" => :build
    depends_on "doxygen" => [:build, "with-dot"]
  end

  def install
    args = std_cmake_args
    args << "-DQT4_BUILD=#{build.with?("qt5") ? "OFF" : "ON"}"
    args << "-DBUILD_TESTS=#{build.with?("tests") ? "ON" : "OFF"}"

    # Plugins (qca-cyrus-sasl, qca-logger, qca-softstore are always built)
    args << "-DWITH_ossl_PLUGIN=YES"
    args << "-DWITH_botan_PLUGIN=#{build.with?("botan") ? "YES" : "NO"}"
    args << "-DWITH_gcrypt_PLUGIN=#{build.with?("libgcrypt") ? "YES" : "NO"}"
    args << "-DWITH_gnupg_PLUGIN=#{build.with?("gnupg") ? "YES" : "NO"}"
    args << "-DWITH_nss_PLUGIN=#{build.with?("nss") ? "YES" : "NO"}"
    args << "-DWITH_pkcs11_PLUGIN=#{build.with?("pkcs11-helper") ? "YES" : "NO"}"

    qca_arch = buildpath/"images/qca-arch.png"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"

      # Don't block install on test failure, as it may be just one plugin, or
      # the randomly failing FileWatch test
      safe_system "make test 2>&1 | tee #{prefix}/make-test.log" if build.with? "tests"

      if build.with? "api-docs"
        system "make", "doc"
        doc.install "apidocs/html"
        (doc/"html").install qca_arch
      end
    end

    # Symlink plugins into qt formula prefix
    # First move plugins out of lib, or segfault on unload of plugin provider instance
    qca_plugins = "#{prefix}/qca_plugins"
    mkpath qca_plugins
    mv "#{lib}/qca/crypto", "#{qca_plugins}/crypto"
    qt_prefix = build.with?("qt5") ? Formula["qt5"].prefix : Formula["qt"].prefix
    ln_sf "#{qca_plugins}/crypto", qt_prefix/"plugins/"
  end

  def post_install
    certs_store = prefix/"certs"
    root_certs = certs_store/"rootcerts.pem"

    # Culled from openssl formula
    keychains = %w[
      /Library/Keychains/System.keychain
      /System/Library/Keychains/SystemRootCertificates.keychain
    ]
    certs_store.mkpath
    rm_f root_certs
    root_certs.atomic_write `security find-certificate -a -p #{keychains.join(" ")}`
  end

  test do
    assert pipe_output("#{bin}/qcatool plugins").include?("qca-ossl")
  end
end
