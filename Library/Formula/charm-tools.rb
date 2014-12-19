require 'formula'

class CharmTools < Formula
  homepage 'https://launchpad.net/charm-tools'
  url 'https://launchpad.net/charm-tools/1.3/1.3.3/+download/charm-tools-1.3.3.tar.gz'
  sha1 'd7455d1caae0e572ecad47fe0628f85611002223'

  depends_on :python if MacOS.version <= :snow_leopard
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
