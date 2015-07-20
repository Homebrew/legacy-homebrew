class Khal < Formula
  desc "CLI calendar application."
  homepage "https://github.com/geier/khal"
  url "https://pypi.python.org/packages/source/k/khal/khal-0.6.0.tar.gz"
  sha256 "1a2e8d56d20b12ed2c3ef2468ff0ce0c658a8a566b249821b0f4b30cce8ada9a"

  bottle do
    cellar :any
    sha256 "1796df34f81473c1ad2eb8527803b8b30c993e20199e00d3457b8c3289b07244" => :yosemite
    sha256 "67b02a0db471f4799ee54b65b39a3067af158a18d8bea6537eb681185456a4f3" => :mavericks
    sha256 "06f4f64db39be3cf026439ab604bdb6e83c1db0ef25ce0e3a49076c74764c8d2" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pkginfo" do
    url "https://pypi.python.org/packages/source/p/pkginfo/pkginfo-1.2.1.tar.gz"
    sha256 "ad3f6dfe8a831f96a7b56a588ca874137ca102cc6b79fc9b0a1c3b7ab7320f3c"
  end

  resource "icalendar" do
    url "https://pypi.python.org/packages/source/i/icalendar/icalendar-3.9.0.tar.gz"
    sha256 "93d0b94eab23d08f62962542309916a9681f16de3d5eca1c75497f30f1b07792"
  end

  resource "urwid" do
    url "https://pypi.python.org/packages/source/u/urwid/urwid-1.3.0.tar.gz"
    sha256 "29f04fad3bf0a79c5491f7ebec2d50fa086e9d16359896c9204c6a92bc07aba2"
  end

  resource "pyxdg" do
    url "https://pypi.python.org/packages/source/p/pyxdg/pyxdg-0.25.tar.gz"
    sha256 "81e883e0b9517d624e8b0499eb267b82a815c0b7146d5269f364988ae031279d"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2015.4.tar.gz"
    sha256 "c4ee70cb407f9284517ac368f121cf0796a7134b961e53d9daf1aaae8f44fb90"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.2.tar.gz"
    sha256 "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-4.0.tar.gz"
    sha256 "f49e03611f5f2557788ceeb80710b1c67110f97c5e6740b97edf70245eea2409"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "tzlocal" do
    url "https://pypi.python.org/packages/source/t/tzlocal/tzlocal-1.1.3.tar.gz"
    sha256 "1950d112ed1b717683280d54f1e7a4533564d479127162cbf247bd0fb3708983"
  end

  resource "vdirsyncer" do
    url "https://pypi.python.org/packages/source/v/vdirsyncer/vdirsyncer-0.4.4.tar.gz"
    sha256 "d6f6fa7730c1c87dd10bb5bad3143515ae983987bf4154b5e53cc74aa720abd2"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-3.4.4.tar.gz"
    sha256 "b3d362bac471172747cda3513238f115cbd6c5f8b8e6319bf6a97a7892724099"
  end

  resource "requests-toolbelt" do
    url "https://pypi.python.org/packages/source/r/requests-toolbelt/requests-toolbelt-0.4.0.tar.gz"
    sha256 "15b74b90a63841b8430d6301e5062cd92929b1074b0c95bf62166b8239db1a96"
  end

  resource "atomicwrites" do
    url "https://pypi.python.org/packages/source/a/atomicwrites/atomicwrites-0.1.5.tar.gz"
    sha256 "9b16a8f1d366fb550f3d5a5ed4587022735f139a4187735466f34cf4577e4eaa"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/khal", "--version"
  end
end
