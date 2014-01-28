require 'formula'

class Mitmproxy < Formula
  homepage 'http://mitmproxy.org'
  url 'http://mitmproxy.org/download/mitmproxy-0.9.2.tar.gz'
  sha1 '7fa95ef27a4ac5ec85010f4ddb85cf6b7f17ef27'

  option 'with-pyamf', 'Enable action message format (AMF) support for python'

  depends_on :python
  depends_on 'protobuf' => :optional

  resource 'pyopenssl' do
    url 'https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.13.1.tar.gz'
    sha1 '60633ebb821d48d7132a436c897288ec0121b892'
  end

  resource 'pillow' do
    url 'https://github.com/python-imaging/Pillow/archive/2.3.0.tar.gz'
    sha1 'f269109be21d27df3210e43fe11a17657bbfc261'
  end

  resource 'flask' do
    url 'https://pypi.python.org/packages/source/F/Flask/Flask-0.10.1.tar.gz'
    sha1 'd3d078262b053f4438e2ed3fd6f9b923c2c92172'
  end

  resource 'lxml' do
    url 'https://pypi.python.org/packages/source/l/lxml/lxml-3.2.3.tar.gz'
    sha1 '33a3017090903f13b329ef3d81b5082e8d6463f7'
  end

  resource 'netlib' do
    url 'https://pypi.python.org/packages/source/n/netlib/netlib-0.9.2.tar.gz'
    sha1 '7c62c96829295d8e55f8644f242959f6a150720e'
  end

  resource 'pyasn1' do
    url 'https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.7.tar.gz'
    sha1 'e32b91c5a5d9609fb1d07d8685a884bab22ca6d0'
  end

  resource 'urwid' do
    url 'https://pypi.python.org/packages/source/u/urwid/urwid-1.1.1.tar.gz'
    sha1 '0d6aa34975bb516565cfbf951487d26161e400b7'
  end

  if build.with? 'pyamf'
    resource 'pyamf' do
      url 'https://pypi.python.org/packages/source/P/PyAMF/PyAMF-0.6.1.tar.gz'
      sha1 '825a5ee167c89d3a026347b409ae26cbf6c68530'
    end
  end

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    resource('pyopenssl').stage { system "python", *install_args }
    resource('pillow').stage { system "python", *install_args }
    resource('flask').stage { system "python", *install_args }
    resource('lxml').stage { system "python", *install_args }
    resource('netlib').stage { system "python", *install_args }
    resource('pyasn1').stage { system "python", *install_args }
    resource('urwid').stage { system "python", *install_args }
    if build.with? 'pyamf'
      resource('pyamf').stage { system "python", *install_args }
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end
end
