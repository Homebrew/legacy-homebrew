class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.torproject.org/"
  url "https://pypi.python.org/packages/source/o/ooniprobe/ooniprobe-1.3.1.tar.gz"
  sha256 "0d90b85f74c9dd98f8f111c058a2a734aa5e0aea927b2653f7a0387c93e090b2"

  bottle do
    cellar :any
    sha256 "07723f65b43ed2262115f2d3e854e68ddd19c3656fa26dabaa4774ef7067e894" => :el_capitan
    sha256 "4afd88781ca598afe301f838eea08e511bf032591d51a21006298a75c435ac69" => :yosemite
    sha256 "900d2bee5c9769e72ef89f6f20d7a8ee46811810e42fb2a645dceceffdcb1a01" => :mavericks
  end

  depends_on "geoip"
  depends_on "libdnet"
  depends_on "libyaml"
  depends_on "openssl"
  depends_on "tor"
  depends_on :python if MacOS.version <= :snow_leopard

  # these 4 need to come first or else cryptography will let setuptools
  # easy_install them (which is bad)
  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-1.5.2.tar.gz"
    sha256 "da9bde99872e46f7bb5cff40a9b1cc08406765efafb583c704de108b6cb821dd"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/source/e/enum34/enum34-1.0.4.tar.gz"
    sha256 "d3c19f26a6a34629c18c775f59dfc5dd595764c722b57a2da56ebfb69b94e447"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.8.tar.gz"
    sha256 "5d33be7ca0ec5997d76d29ea4c33b65c00c0231407fff975199d7f40530b8347"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end
  # end "these 4"

  resource "characteristic" do
    url "https://pypi.python.org/packages/source/c/characteristic/characteristic-14.3.0.tar.gz"
    sha256 "ded68d4e424115ed44e5c83c2a901a0b6157a959079d7591d92106ffd3ada380"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/source/c/cryptography/cryptography-1.2.3.tar.gz"
    sha256 "8eb11c77dd8e73f48df6b2f7a7e16173fe0fe8fdfe266232832e88477e08454e"
  end

  resource "GeoIP" do
    url "https://pypi.python.org/packages/source/G/GeoIP/GeoIP-1.3.2.tar.gz"
    sha256 "a890da6a21574050692198f14b07aa4268a01371278dfc24f71cd9bc87ebf0e6"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/source/i/idna/idna-2.0.tar.gz"
    sha256 "16199aad938b290f5be1057c0e1efc6546229391c23cea61ca940c115f7d3d3b"
  end

  resource "ipaddress" do
    url "https://pypi.python.org/packages/source/i/ipaddress/ipaddress-1.0.14.tar.gz"
    sha256 "226f4be44c6cb64055e23060848266f51f329813baae28b53dc50e93488b3b3e"
  end

  resource "ipaddr" do
    url "https://pypi.python.org/packages/source/i/ipaddr/ipaddr-2.1.11.tar.gz"
    sha256 "1b555b8a8800134fdafe32b7d0cb52f5bdbfdd093707c3dd484c5ea59f1d98b7"
  end

  resource "Parsley" do
    url "https://pypi.python.org/packages/source/P/Parsley/Parsley-1.2.tar.gz"
    sha256 "50d30cee70770fd44db7cea421cb2fb75af247c3a1cd54885c06b30a7c85dd23"
  end

  resource "pyasn1-modules" do
    url "https://pypi.python.org/packages/source/p/pyasn1-modules/pyasn1-modules-0.0.7.tar.gz"
    sha256 "794dbcef4b7124b8271f12eb7eea0d37b466012f11ce023f91e2e2082df11c7e"
  end

  resource "pyOpenSSL" do
    url "https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.15.1.tar.gz"
    sha256 "f0a26070d6db0881de8bcc7846934b7c3c930d8f9c79d45883ee48984bc0d672"
  end

  resource "pypcap" do
    url "https://pypi.python.org/packages/source/p/pypcap/pypcap-1.1.1.tar.gz"
    sha256 "b310d5af36f5d68ef4217fda68086ffce56345b415eaac15ad618f94057b017b"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "scapy" do
    url "https://bitbucket.org/secdev/scapy/downloads/scapy-2.3.1.zip"
    sha256 "8972c02e39a826a10c02c2bdd5025f7251dce9589c57befd9bb55c65f02e4934"
  end

  resource "service_identity" do
    url "https://pypi.python.org/packages/source/s/service_identity/service_identity-14.0.0.tar.gz"
    sha256 "3105a319a7c558490666694f599be0c377ad54824eefb404cde4ce49e74a4f5a"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "Twisted" do
    url "https://pypi.python.org/packages/source/T/Twisted/Twisted-15.4.0.tar.bz2"
    sha256 "78862662fa9ae29654bc2b9d349c3f1d887e6b2ed978512c4442d53ea861f05c"
  end

  resource "txsocksx" do
    url "https://pypi.python.org/packages/source/t/txsocksx/txsocksx-1.15.0.2.tar.gz"
    sha256 "4f79b5225ce29709bfcee45e6f726e65b70fd6f1399d1898e54303dbd6f8065f"
  end

  resource "txtorcon" do
    url "https://pypi.python.org/packages/source/t/txtorcon/txtorcon-0.13.0.tar.gz"
    sha256 "3218d0fa0c22f49eee9324a5862b2d53ef77d5cb8e555e2bcffc24070aaeca7d"
  end

  resource "zope.interface" do
    url "https://pypi.python.org/packages/source/z/zope.interface/zope.interface-4.1.2.tar.gz"
    sha256 "441fefcac1fbac57c55239452557d3598571ab82395198b2565a29d45d1232f6"
  end

  def install
    ENV["PYTHONPATH"] = Formula["libdnet"].opt_lib/"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # namespace package hint
    touch libexec/"vendor/lib/python2.7/site-packages/zope/__init__.py"

    inreplace "requirements.txt" do |s|
      # provided by libdnet
      s.gsub! "pydumbnet", ""
      # don't expect the pypi version of scapy
      s.gsub! /scapy-real.*/, "scapy>=2.3.1"
    end

    # force a distutils install
    inreplace "setup.py", "def run(", "def norun("
    (buildpath/"ooni/settings.ini").atomic_write <<-EOS.undent
      [directories]
      usr_share = #{share}/ooni
      var_lib = #{var}/lib/ooni
    EOS

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    man1.install Dir["data/*.1"]
    (share/"ooni").install Dir["data/*"]
    (var/"lib/ooni").mkpath
  end

  def post_install
    system bin/"ooniresources", "--update-inputs", "--update-geoip"
  end

  def caveats; <<-EOS.undent
    Decks are installed to #{HOMEBREW_PREFIX}/share/ooni.
    EOS
  end

  test do
    (testpath/"hosts.txt").write "github.com:443\n"
    system bin/"ooniprobe", "blocking/tcp_connect", "-f", testpath/"hosts.txt"
  end
end
