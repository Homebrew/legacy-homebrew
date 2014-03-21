require 'formula'

class Euca2ools < Formula

  homepage 'https://github.com/eucalyptus/euca2ools'
  url 'https://github.com/eucalyptus/euca2ools/archive/v3.1.0-pre1.tar.gz'
  sha1 'a214943b8c641395b2a4452671d3dd0097db38a6'
  head 'https://github.com/eucalyptus/euca2ools.git', :branch => 'master'

  depends_on :python
  depends_on 'pypy'
  depends_on 'openssl'
  depends_on 'libxml2'
  depends_on 'brew-pip'

  resource 'requestbuilder' do
    url 'https://github.com/boto/requestbuilder/archive/v0.2.0-pre1.tar.gz'
    sha1 '71c9bd5c846aa7125cd1b2b2c0fd286e6b2d5fb0'
  end

  resource 'requests' do
    url 'https://github.com/kennethreitz/requests/tarball/master/kennethreitz-requests-v2.2.1-56-g110048f.tar'
    sha1 'd23294b6b5dabd88240dbda8c7cfcc6ee35d705b'
  end

  resource 'setuptools' do
    url 'https://pypi.python.org/packages/source/s/setuptools/setuptools-2.2.tar.gz'
    sha1 '547eff11ea46613e8a9ba5b12a89c1010ecc4e51'
  end

  resource 'pip' do
    url 'https://pypi.python.org/packages/source/p/pip/pip-1.5.4.tar.gz'
    sha1 '35ccb7430356186cf253615b70f8ee580610f734'
  end

  resource 'six' do
    url 'https://pypi.python.org/packages/source/s/six/six-1.6.1.tar.gz'
    sha1 '2a7941cc2233d9ad6d7d54dd5265d1eb9726c5a1'
  end

  def install

    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    resource('requestbuilder').stage { system "python", *install_args }
    resource('requests').stage { system "python", *install_args }
    resource('setuptools').stage { system "python", *install_args }
    resource('pip').stage { system "python", *install_args }
    resource('six').stage { system "python", *install_args }

    system "/usr/local/bin/pip", "install", "lxml"
    system "python", "setup.py", "install", "--single-version-externally-managed", "--record=installed.txt", "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/euca-version"
  end

end