require 'formula'

class Cookiecutter < Formula
  homepage 'https://github.com/audreyr/cookiecutter'
  url 'https://pypi.python.org/packages/source/c/cookiecutter/cookiecutter-0.8.0.tar.gz'
  sha1 'f8d68f73b5a36540a8798c0aee4eebda028653c5'

  bottle do
    cellar :any
    sha1 "ddaf7d11f1fcc1c8843cabd041f074764725a0f0" => :yosemite
    sha1 "90a6ae68fd96ceab215f2dfaab0cc3ac9525908d" => :mavericks
    sha1 "4c69f62dfffca5508feb0a5753dd0d4b7efb8ebe" => :mountain_lion
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
