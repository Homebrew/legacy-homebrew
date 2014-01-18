require 'formula'

class AppscaleTools < Formula
  homepage 'https://github.com/AppScale/appscale-tools'
  url 'https://github.com/AppScale/appscale-tools/archive/1.13.0.tar.gz'
  sha1 '72d9fc10dddd0bf2c28c341d07263efd4481e591'

  depends_on :python
  depends_on 'libyaml'

  resource 'termcolor' do
    url 'https://pypi.python.org/packages/source/t/termcolor/termcolor-1.1.0.tar.gz'
    sha1 '52045880a05c0fbd192343d9c9aad46a73d20e8c'
  end
  
  resource 'SOAPpy' do
    url 'https://pypi.python.org/packages/source/S/SOAPpy/SOAPpy-0.12.5.tar.gz'
    sha1 'dd2245aced212a7e333a594c8b4be5cf4d1c89ff'
  end

  resource 'pyyaml' do
    url 'https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.10.tar.gz'
    sha1 '476dcfbcc6f4ebf3c06186229e8e2bd7d7b20e73'
  end

  resource 'boto' do
    url 'https://pypi.python.org/packages/source/b/boto/boto-2.23.0.tar.gz'
    sha1 'f09be44dfbc2601c523272eff424b947f9551146'
  end

  resource 'argparse' do
    url 'http://argparse.googlecode.com/files/argparse-1.2.1.tar.gz'
    sha1 'caadac82aa2576d6b445058c1fcf6ef0b14dbaa1'
  end

  resource 'oauth2client' do
    url 'https://pypi.python.org/packages/source/o/oauth2client/oauth2client-1.2.tar.gz'
    sha1 'd38bf2d5392e4e4eea66b039a408079f6fe008d0'
  end

  resource 'google-api-python-client' do
    url 'https://pypi.python.org/packages/source/o/oauth2client/oauth2client-1.2.tar.gz'
    sha1 '31ddb6e125b0683d29493c9f486d48a4f63c913b'
  end

  resource 'httplib2' do
    url 'https://pypi.python.org/packages/source/h/httplib2/httplib2-0.8.tar.gz'
    sha1 '3821350a9612b3e1fb382d55484b2465cb8fb9c5'
  end

  resource 'python-gflags' do
    url 'https://pypi.python.org/packages/source/p/python-gflags/python-gflags-2.0.tar.gz'
    sha1 '1529a1102da2fc671f2a9a5e387ebabd1ceacbbf'
  end

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    resource('termcolor').stage { system "python", *install_args }
    resource('pyyaml').stage { system "python", *install_args }
    resource('SOAPpy').stage { system "python", *install_args }
    resource('boto').stage { system "python", *install_args }
    resource('argparse').stage { system "python", *install_args }
    resource('oauth2client').stage { system "python", *install_args }
    resource('google-api-python-client').stage { system "python", *install_args }
    resource('httplib2').stage { system "python", *install_args }
    resource('python-gflags').stage { system "python", *install_args }

    Dir.glob('bin/appscale*') do |command_file|
      inreplace command_file do |s|
        s.gsub! 'os.path.dirname(__file__))', 'os.path.dirname(os.path.realpath(__file__))'
      end
    end
    prefix.install 'bin', 'lib', 'templates', 'LICENSE', 'README.md'
  end
end
