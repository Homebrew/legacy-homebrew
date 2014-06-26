require 'formula'

class Mitmproxy < Formula
  homepage 'http://mitmproxy.org'
  url 'http://mitmproxy.org/download/mitmproxy-0.10.1.tar.gz'
  sha1 '8feb1b4d8d7b8e6713d08aa434667275215f14c4'

  option 'with-pyamf', 'Enable action message format (AMF) support for python'
  option 'with-cssutils', 'Enable beautification of CSS responses'

  depends_on 'freetype'
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on 'protobuf' => :optional

  resource 'pyopenssl' do
    url 'https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.14.tar.gz'
    sha1 'eb51f23f29703b647b0f194beaa9b2412c05e0f6'
  end

  resource 'pillow' do
    url 'https://github.com/python-imaging/Pillow/archive/2.4.0.tar.gz'
    sha1 '2e07dd7545177019331e8f3916335b69869e82b0'
  end

  resource 'flask' do
    url 'https://pypi.python.org/packages/source/F/Flask/Flask-0.10.1.tar.gz'
    sha1 'd3d078262b053f4438e2ed3fd6f9b923c2c92172'
  end

  resource 'lxml' do
    url 'https://pypi.python.org/packages/source/l/lxml/lxml-3.3.5.tar.gz'
    sha1 '7a6e92f8ca482aab79835e1c9cd8410400792cd9'
  end

  resource 'netlib' do
    url 'https://pypi.python.org/packages/source/n/netlib/netlib-0.10.tar.gz'
    sha1 'd8bcd71a6670377ef70bb25e0b6a81679e8b651a'
  end

  resource 'pyasn1' do
    url 'https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.7.tar.gz'
    sha1 'e32b91c5a5d9609fb1d07d8685a884bab22ca6d0'
  end

  resource 'urwid' do
    url 'https://pypi.python.org/packages/source/u/urwid/urwid-1.2.1.tar.gz'
    sha1 '28bd77014cce92bcb09ccc11f93e558d02265082'
  end

  if build.with? 'pyamf'
    resource 'pyamf' do
      url 'https://pypi.python.org/packages/source/P/PyAMF/PyAMF-0.6.1.tar.gz'
      sha1 '825a5ee167c89d3a026347b409ae26cbf6c68530'
    end
  end

  if build.with? 'cssutils'
    resource 'cssutils' do
      url 'https://pypi.python.org/packages/source/c/cssutils/cssutils-1.0.zip'
      sha1 '341e57dbb02b699745b13a9a3296634209d26169'
    end
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    resource("pillow").stage do
      inreplace "setup.py", "'brew', '--prefix'", "'#{HOMEBREW_PREFIX}/bin/brew', '--prefix'"
      system "python", *install_args
    end

    res = %w(pyopenssl flask lxml netlib pyasn1 urwid)
    res << 'pyamf' if build.with? 'pyamf'
    res << 'cssutils' if build.with? 'cssutils'

    res.each do |r|
      resource(r).stage { system "python", *install_args }
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end
end
