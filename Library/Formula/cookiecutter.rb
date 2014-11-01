require 'formula'

class Cookiecutter < Formula
  homepage 'https://github.com/audreyr/cookiecutter'
  url 'https://pypi.python.org/packages/source/c/cookiecutter/cookiecutter-0.8.0.tar.gz'
  sha1 'f8d68f73b5a36540a8798c0aee4eebda028653c5'

  bottle do
    cellar :any
    sha1 "f0ac7ce389eedcdc2e4b67a5e2fb71747c45adf7" => :mavericks
    sha1 "c8425e83e01c889d090cc6596b5c9900fe53d4bb" => :mountain_lion
    sha1 "d20dd767a6fec5a5e305d31eef2f91cf1182ced3" => :lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    system "python", "setup.py", "install", "--prefix=#{libexec}"

    bin.install Dir[libexec/'bin/*']
    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system "#{bin}/cookiecutter", "--help"
  end
end
