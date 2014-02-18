require 'formula'

class SaltHeadDownloadStrategy < GitDownloadStrategy
  def stage
    @clone.cd {reset}
    safe_system 'git', 'clone', @clone, '.'
  end
end

class Saltstack < Formula
  homepage 'http://www.saltstack.org'
  url 'https://pypi.python.org/packages/source/s/salt/salt-0.17.5.tar.gz'
  sha1 '7751eb59f3b52e7da541121cc4a543afd7f609f9'

  head 'https://github.com/saltstack/salt.git', :branch => 'develop',
    :using => SaltHeadDownloadStrategy, :shallow => false

  devel do
    url 'https://github.com/saltstack/salt/archive/v2014.1.0rc3.tar.gz'
    sha1 '2c1bd6d9b26b66ef32b30af9ccae38733383efce'
  end

  depends_on :python
  depends_on 'swig' => :build
  depends_on 'zeromq'
  depends_on 'libyaml'

  resource 'pycrypto' do
    url 'https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.tar.gz'
    sha1 'c17e41a80b3fbf2ee4e8f2d8bb9e28c5d08bbb84'
  end

  resource 'm2crypto' do
    url 'https://pypi.python.org/packages/source/M/M2Crypto/M2Crypto-0.21.1.tar.gz'
    sha1 '3c7135b952092e4f2eee7a94c5153319cccba94e'
  end

  resource 'pyyaml' do
    url 'https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.10.tar.gz'
    sha1 '476dcfbcc6f4ebf3c06186229e8e2bd7d7b20e73'
  end

  resource 'markupsafe' do
    url 'https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.18.tar.gz'
    sha1 '9fe11891773f922a8b92e83c8f48edeb2f68631e'
  end

  resource 'jinja2' do
    url 'https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.1.tar.gz'
    sha1 'a9b24d887f2be772921b3ee30a0b9d435cffadda'
  end

  resource 'pyzmq' do
    url 'https://pypi.python.org/packages/source/p/pyzmq/pyzmq-14.0.0.tar.gz'
    sha1 'a57a32f3fdedd7a9d3659926648a93895eb7c3c4'
  end

  resource 'msgpack-python' do
    url 'https://pypi.python.org/packages/source/m/msgpack-python/msgpack-python-0.4.0.tar.gz'
    sha1 '5915f60033168a7b6f1e76ddb8a514f84ebcdf81'
  end

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    resource('pycrypto').stage { system "python", *install_args }
    resource('pyyaml').stage { system "python", *install_args }
    resource('pyzmq').stage { system "python", *install_args }
    resource('msgpack-python').stage { system "python", *install_args }
    resource('markupsafe').stage { system "python", *install_args }
    resource('m2crypto').stage { system "python", *install_args }
    resource('jinja2').stage { system "python", *install_args }

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    man1.install Dir['doc/man/*.1']
    man7.install Dir['doc/man/*.7']

    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system "#{bin}/salt", "--version"
  end
end
