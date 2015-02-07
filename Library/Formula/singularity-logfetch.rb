class SingularityLogfetch < Formula
  homepage "https://github.com/HubSpot/Singularity"
  url "https://github.com/HubSpot/Singularity/archive/logfetch-0.8.0.tar.gz"
  sha1 "8bba19056183df3222b1371f9f0fc00e48ef5219"

  head "https://github.com/HubSpot/Singularity.git"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.2.2.tar.gz"
    md5 "38589b29d9120b19dfca32f86406a1f5"
  end

  resource "ConfigParser" do
    url "https://pypi.python.org/packages/source/c/configparser/configparser-3.5.0b2.tar.gz"
    md5 "ad2a71db8bd9a017ed4735eac7acfa07"
  end

  resource "gevent" do
    url "https://pypi.python.org/packages/source/g/gevent/gevent-1.0.1.tar.gz"
    md5 "7b952591d1a0174d6eb6ac47bd975ab6"
  end

  resource "greenlet" do
    url "https://pypi.python.org/packages/source/g/greenlet/greenlet-0.4.5.zip"
    md5 "ce383f6475e6311cf8932ea779938703"
  end

  resource "grequests" do
    url "https://pypi.python.org/packages/source/g/grequests/grequests-0.2.0.tar.gz"
    md5 "23186795cf69d127f5e90df665d25387"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.5.0.tar.gz"
    md5 "b8bf3ddca75e7ecf1b6776da1e6e3385"
  end

  resource "termcolor" do
    url "https://pypi.python.org/packages/source/t/termcolor/termcolor-1.1.0.tar.gz"
    md5 "043e89644f8909d462fbbfa511c768df"
  end

  resource "wsgiref" do
    url "https://pypi.python.org/packages/source/w/wsgiref/wsgiref-0.1.2.zip"
    md5 "29b146e6ebd0f9fb119fe321f7bcf6cb"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[argparse ConfigParser gevent greenlet grequests requests termcolor wsgiref].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    Dir.chdir("scripts") {
      ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
      system "python", *Language::Python.setup_install_args(libexec)
    }

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    output = shell_output("#{bin}/logfetch --help")
    assert output.include?("PYTHONPATH")

    output = shell_output("#{bin}/logtail --help")
    assert output.include?("PYTHONPATH")
  end
end
