require 'formula'

class Duplicity < Formula
  homepage 'http://www.nongnu.org/duplicity/'
  url 'http://code.launchpad.net/duplicity/0.6-series/0.6.23/+download/duplicity-0.6.23.tar.gz'
  sha1 '0b8664d55c24957b3b19e903c0d69673f2bfa166'

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on 'librsync'
  depends_on 'gnupg'

  option :universal

  resource 'lockfile' do
    url 'https://pypi.python.org/packages/source/l/lockfile/lockfile-0.9.1.tar.gz'
    sha1 '9870cc7e7d4b23f0b6c39cf6ba597c87871ac6de'
  end

  resource 'paramiko' do
    url 'https://pypi.python.org/packages/source/p/paramiko/paramiko-1.12.1.tar.gz'
    sha1 '3809737533b3055b9822a86bee6bd1629144204d'
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"

    ENV.universal_binary if build.universal?

    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]
    resource('lockfile').stage { system "python", *install_args }
    resource('paramiko').stage { system "python", *install_args }

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system "duplicity", "--version"
  end
end
