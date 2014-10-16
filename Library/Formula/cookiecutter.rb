require 'formula'

class Cookiecutter < Formula
  homepage 'https://github.com/audreyr/cookiecutter'
  url 'https://pypi.python.org/packages/source/c/cookiecutter/cookiecutter-0.7.2.tar.gz'
  sha1 '58b318de167b8812bcffd94943a6640f4ab92c22'

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
