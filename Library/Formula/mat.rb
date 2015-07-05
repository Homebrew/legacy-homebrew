class Mat < Formula
  desc "Metadata anonymization toolkit"
  homepage "https://mat.boum.org/"
  url "https://mat.boum.org/files/mat-0.5.3.tar.xz"
  sha256 "616fc4ba13a7ce2a20acd6639a776fa4ee6a61caf999ed64b4545d3f83a41cfd"

  bottle do
    cellar :any
    sha1 "3476e92b91bddb20d386c35c997662fe08805da6" => :yosemite
    sha1 "2f30838e07c7c342c01afa3a7faaa5cde129b4ab" => :mavericks
    sha1 "810fe4dfe335c5dc8331734b1ea9abbe207b446d" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on "coreutils"
  depends_on "poppler"
  depends_on "exiftool" => :optional

  option "with-massive-audio", "Enable massive audio format support"

  resource "hachoir-core" do
    url "https://pypi.python.org/packages/source/h/hachoir-core/hachoir-core-1.3.3.tar.gz"
    sha256 "ecf5d16eccc76b22071d6062e54edb67595f70d827644d3a6dff04289b4058df"
  end

  resource "hachoir-parser" do
    url "https://pypi.python.org/packages/source/h/hachoir-parser/hachoir-parser-1.3.4.tar.gz"
    sha256 "775be5e10d72c6122b1ba3202dfce153c09ebcb60080d8edbd51aa89aa4e6b3f"
  end

  resource "pdfrw" do
    url "https://pypi.python.org/packages/source/p/pdfrw/pdfrw-0.1.tar.gz"
    sha256 "8a85cb87b888c030d87cc3fce10ad93e5f99e721b80b99bf50e29a074c048f83"
  end

  resource "distutils-extra" do
    url "https://launchpad.net/python-distutils-extra/trunk/2.38/+download/python-distutils-extra-2.38.tar.gz"
    sha256 "3d100d5d3492f40b3e7a6a4500f71290bfa91e2c50dc31ba8e3ff9b5d82ca153"
  end

  resource "mutagen" do
    url "https://pypi.python.org/packages/source/m/mutagen/mutagen-1.28.tar.gz"
    sha256 "7d45889c060fdb16aea1733cee92d6dcaa04b8c8574802eb7b43a9f465fa3ca9"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[hachoir-core hachoir-parser pdfrw distutils-extra].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    if build.with? "massive-audio"
      resource("mutagen").stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    # Since we don't support it, Let's remove the GUI binary.
    rm bin/"mat-gui"
    # Install manpages into expected directory.
    man1.install Dir["*.1"]
  end

  def caveats; <<-EOS.undent
      MAT was built without PDF support nor GUI.
    EOS
  end

  test do
    system "#{bin}/mat", "-l"
    system "touch", "foo"
    system "tar", "cf", "foo.tar", "foo"
    system "#{bin}/mat", "-c", "foo.tar"
  end
end
