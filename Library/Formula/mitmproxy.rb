require 'formula'

class Mitmproxy < Formula
  homepage 'http://mitmproxy.org'
  url 'http://mitmproxy.org/download/mitmproxy-0.10.tar.gz'
  sha1 'de30fe4744d66a072b225da05d28f89ab2020391'

  option 'with-pyamf', 'Enable action message format (AMF) support for python'
  option 'with-cssutils', 'Enable beautification of CSS responses'

  depends_on :python if MacOS.version <= :snow_leopard
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
    url 'https://pypi.python.org/packages/source/l/lxml/lxml-3.3.0.tar.gz'
    sha1 '7cff413526c9e797fd0b8ced37144e5e89ffc66e'
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
    url 'https://pypi.python.org/packages/source/u/urwid/urwid-1.1.2.tar.gz'
    sha1 '288f61b444b7f21964fdee33e656da4abeb76c53'
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

    resource('pillow').stage do
      # Disable freetype. Pillow tries really hard to find it, including
      # querying Homebrew and looking for an X11 installation, but our
      # compiler wrappers will filter out the paths, breaking the build.
      (buildpath/"setup.cfg").write "[build_ext]\ndisable-freetype=1\n"
      system "python", *install_args
    end

    resource('pyopenssl').stage { system "python", *install_args }
    resource('flask').stage { system "python", *install_args }
    resource('lxml').stage { system "python", *install_args }
    resource('netlib').stage { system "python", *install_args }
    resource('pyasn1').stage { system "python", *install_args }
    resource('urwid').stage { system "python", *install_args }
    if build.with? 'pyamf'
      resource('pyamf').stage { system "python", *install_args }
    end
    if build.with? 'cssutils'
      resource('cssutils').stage { system "python", *install_args }
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end
end
