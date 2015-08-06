class MusicBox < Formula
  desc "A concise command line interface musicbox"
  homepage "https://github.com/darknessomi/musicbox"
  url "https://pypi.python.org/packages/source/N/NetEase-MusicBox/NetEase-MusicBox-0.1.6.5.tar.gz"
  version "0.1.6.5"
  sha256 "8383d773bd1d4f5e1f4b41897fe34e3dac25c47d3f1b59f1cef62c35ce14a07e"

  depends_on "mpg123"
  depends_on :python if MacOS.version <= :snow_leopard

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-18.1.tar.gz"
    sha256 "ffe37ddc2d4eba71c5727f8875dad74c038200a570cc10eab38cb63527f80ee3"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "beautifulsoup4" do
    url "https://pypi.python.org/packages/source/b/beautifulsoup4/beautifulsoup4-4.4.0.tar.gz"
    sha256 "5dacd244c1f10be8c9a0a8bcc361296bdaad9cff49bb422ef84d09a5e65a0e3c"
  end

  def install
    xy = Language::Python.major_minor_version "python"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    %w[setuptools requests pycrypto beautifulsoup4].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end
  
end
