require 'formula'

class CharmTools < Formula
  homepage 'https://launchpad.net/charm-tools'
  url 'https://launchpad.net/charm-tools/1.2/1.2.7/+download/charm-tools-1.2.7.tar.gz'
  sha1 '428b7204bdd8b726a87653350082fb03841441ae'

  depends_on :python
  depends_on 'libyaml'

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    system "python", "setup.py", "install", "--prefix=#{libexec}"

    bin.install Dir[libexec/'bin/*charm*']
    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system "#{bin}/charm", "list"
  end
end
