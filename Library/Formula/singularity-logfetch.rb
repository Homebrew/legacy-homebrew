class SingularityLogfetch < Formula
  homepage "https://github.com/HubSpot/Singularity"
  url "https://github.com/HubSpot/Singularity/archive/logfetch-0.8.0.tar.gz"
  sha1 "8bba19056183df3222b1371f9f0fc00e48ef5219"

  head "https://github.com/HubSpot/Singularity.git"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.2.2.tar.gz"
    sha1 "d5eb880eafd4aae5f66f9fe94262571725d1b036"
  end

  resource "ConfigParser" do
    url "https://pypi.python.org/packages/source/c/configparser/configparser-3.5.0b2.tar.gz"
    sha1 "253a8eeb97e1a6b983a4d5dcaa74d8f15078e0a4"
  end

  resource "gevent" do
    url "https://pypi.python.org/packages/source/g/gevent/gevent-1.0.1.tar.gz"
    sha1 "2cc1b6e1fa29b30ea881fa6a195e57faaf089ae8"
  end

  resource "greenlet" do
    url "https://pypi.python.org/packages/source/g/greenlet/greenlet-0.4.5.zip"
    sha1 "97f18d651595bd30243ad2f4702764791e57fa6e"
  end

  resource "grequests" do
    url "https://pypi.python.org/packages/source/g/grequests/grequests-0.2.0.tar.gz"
    sha1 "9a55beb7a5c7c2ea0e59497442164ec6a0958204"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.5.0.tar.gz"
    sha1 "d60dfaaa0b4b62a6646fcb6c3954ea369317ca9f"
  end

  resource "termcolor" do
    url "https://pypi.python.org/packages/source/t/termcolor/termcolor-1.1.0.tar.gz"
    sha1 "52045880a05c0fbd192343d9c9aad46a73d20e8c"
  end

  resource "wsgiref" do
    url "https://pypi.python.org/packages/source/w/wsgiref/wsgiref-0.1.2.zip"
    sha1 "80b7e9b039e40a2f8419e00b393a6516d80cf8de"
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
