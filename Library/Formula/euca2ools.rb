require "formula"

class Euca2ools < Formula
  homepage "https://github.com/eucalyptus/euca2ools"
  url "https://github.com/eucalyptus/euca2ools/archive/3.0.2.tar.gz"
  sha1 "73e235e7e6b17c8d1fb064c14aa24a3de36640e7"
  head "https://github.com/eucalyptus/euca2ools.git", :branch => "master"

  depends_on :python

  resource "requestbuilder" do
    url "https://github.com/boto/requestbuilder/archive/v0.2.0-pre1.tar.gz"
    sha1 "71c9bd5c846aa7125cd1b2b2c0fd286e6b2d5fb0"
  end

  resource "requests" do
    url "https://github.com/kennethreitz/requests/tarball/master/kennethreitz-requests-v2.2.1-56-g110048f.tar"
    sha1 "d23294b6b5dabd88240dbda8c7cfcc6ee35d705b"
  end

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-2.2.tar.gz"
    sha1 "547eff11ea46613e8a9ba5b12a89c1010ecc4e51"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.6.1.tar.gz"
    sha1 "2a7941cc2233d9ad6d7d54dd5265d1eb9726c5a1"
  end

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-3.3.3.tar.gz"
    sha1 "e701a4d8d7840fdf04944004dc0f38deff65214b"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    # pycrypto's C bindings use flags unrecognized by clang,
    # but since it doesn't use a makefile arg refurbishment
    # is normally not enabled.
    # See https://github.com/Homebrew/homebrew/issues/27639
    ENV.append 'HOMEBREW_CCCFG', 'O'

    resource("requestbuilder").stage { system "python", *install_args }
    resource("requests").stage { system "python", *install_args }
    resource("setuptools").stage { system "python", *install_args }
    resource("lxml").stage { system "python", *install_args }
    resource("six").stage { system "python", *install_args }

    system "python", "setup.py", "install", "--single-version-externally-managed", "--record=installed.txt", "--prefix=#{prefix}"

    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system "#{bin}/euca-version"
  end
end
