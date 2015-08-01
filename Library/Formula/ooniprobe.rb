class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.torproject.org/"
  url "https://pypi.python.org/packages/source/o/ooniprobe/ooniprobe-1.3.0.tar.gz"
  sha256 "ff9c7974937d3d3d5f03fe04d561c5ef31cd4757c4112641fc88308f80cc16a7"

  bottle do
    sha256 "ab26339b18c45f9c84a66329d193f34b78b13c08202cd19dc93a532bf360ef89" => :yosemite
    sha256 "556a2537cb40d931c6ba9cdfcade62f83c3ef14f28a422d0ffbc21c89cc73f3e" => :mavericks
    sha256 "32aeeb7019ac404890ee3827c8f5a3e82ebe7a940bb587482984e7a08eb570e8" => :mountain_lion
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
    url "https://pypi.python.org/packages/source/c/cffi/cffi-0.9.2.tar.gz"
    sha256 "1988ce7ff9c64ecd5077776175e90fd8f0a8c827cb241a23647175ce08126bb2"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/source/e/enum34/enum34-1.0.4.tar.gz"
    sha256 "d3c19f26a6a34629c18c775f59dfc5dd595764c722b57a2da56ebfb69b94e447"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.7.tar.gz"
    sha256 "e4f81d53c533f6bd9526b047f047f7b101c24ab17339c1a7ad8f98b25c101eab"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.10.tar.gz"
    sha256 "957d98b661c0b64b580ab6f94b125e09b6714154ee51de40bca16d3f0076b86c"
  end
  # end "these 4"

  resource "characteristic" do
    url "https://pypi.python.org/packages/source/c/characteristic/characteristic-14.3.0.tar.gz"
    sha256 "ded68d4e424115ed44e5c83c2a901a0b6157a959079d7591d92106ffd3ada380"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/source/c/cryptography/cryptography-0.8.1.tar.gz"
    sha256 "f4e041bc83c1be94d87116a7aa201c378b7c6581be4d83994b2da0a84499f73b"
  end

  resource "GeoIP" do
    url "https://pypi.python.org/packages/source/G/GeoIP/GeoIP-1.3.2.tar.gz"
    sha256 "a890da6a21574050692198f14b07aa4268a01371278dfc24f71cd9bc87ebf0e6"
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
    url "https://pypi.python.org/packages/source/p/pyasn1-modules/pyasn1-modules-0.0.5.tar.gz"
    sha256 "be65f00ed28e30756f1ef39377cb382480a2368699179d646a84d79fe9349941"
  end

  resource "pyOpenSSL" do
    url "https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.14.tar.gz"
    sha256 "a99db8e59c120138ad8a72eecedcc24b4510d2eed3ce48213b7e32f22cc4ee6e"
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
    url "https://pypi.python.org/packages/source/T/Twisted/Twisted-15.0.0.tar.bz2"
    sha256 "ac609262253057cf2aeb9dc049ba7877d646f31b4caef06a50189a023df46b51"
  end

  resource "txsocksx" do
    url "https://pypi.python.org/packages/source/t/txsocksx/txsocksx-1.13.0.3.tar.gz"
    sha256 "df1a9e7062c7e3693c39953705b75e0feb7b8746a05135ffb2b8cd98708c9c43"
  end

  resource "txtorcon" do
    url "https://pypi.python.org/packages/source/t/txtorcon/txtorcon-0.12.0.tar.gz"
    sha256 "206b1bd8a840119c12d9b85d638ab9defec5b376436fa36be9139ab1ebc8cd78"
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
