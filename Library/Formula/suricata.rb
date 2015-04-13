class Suricata < Formula
  homepage "http://suricata-ids.org"
  url "https://www.openinfosecfoundation.org/download/suricata-2.0.7.tar.gz"
  sha256 "c5c3ccebeecbace39df0ff2d50ec4515b541103ffaa5e33cd1dc79d4955c0dfd"

  bottle do
    sha256 "f67922f17fd54ad460fac601c489324a3fc9649332c235b19188db673ac1dd37" => :yosemite
    sha256 "5da62c060b67d37acccef04a3e94da3c6a12a2d33140ece6d83259144bbf4dfb" => :mavericks
    sha256 "4e84abe9e22b63d8ab7161d704da16202bfd8320c50b70a87c5da42ee095efbb" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pkg-config" => :build
  depends_on "libmagic"
  depends_on "libnet"
  depends_on "libyaml"
  depends_on "pcre"
  depends_on "geoip" => :optional
  depends_on "lua" => :optional
  depends_on "luajit" => :optional

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.3.0.tar.gz"
    sha256 "b3a79a23d37b5a02faa550b92cbbbebeb4aa1d77e649c3eb39c19abf5262da04"
  end

  resource "simplejson" do
    url "https://pypi.python.org/packages/source/s/simplejson/simplejson-3.6.5.tar.gz"
    sha256 "2a3189f79d1c7b8a2149a0e783c0b4217fad9b30a6e7d60450f2553dc2c0e57e"
  end

  def install
    libnet = Formula["libnet"]
    libmagic = Formula["libmagic"]

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-libnet-includes=#{libnet.opt_include}
      --with-libnet-libs=#{libnet.opt_lib}
      --with-libmagic-includes=#{libmagic.opt_include}
      --with-libmagic-libraries=#{libmagic.opt_lib}
    ]

    args << "--enable-lua" if build.with? "lua"
    args << "--enable-luajit" if build.with? "luajit"

    if build.with? "geoip"
      geoip = Formula["geoip"]
      args << "--enable-geoip"
      args << "--with-libgeoip-includes=#{geoip.opt_include}"
      args << "--with-libgeoip-libs=#{geoip.opt_lib}"
    end

    system "./configure", *args
    system "make", "install-full"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    # Leave the magic-file: prefix in otherwise it overrides a commented out line rather than intended line.
    inreplace etc/"suricata/suricata.yaml", "magic-file: /usr/share/file/magic", "magic-file: #{libmagic.opt_share}/misc/magic"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/suricata --build-info")
  end
end
