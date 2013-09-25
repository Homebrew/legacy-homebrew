require 'formula'

class PyOpenSsl < Formula
  url 'https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.13.1.tar.gz'
  sha1 '60633ebb821d48d7132a436c897288ec0121b892'
end

class Pil < Formula
  url 'http://effbot.org/media/downloads/PIL-1.1.7.tar.gz'
  sha1 'a1450d0f4f5bd1ca050b75fb363f73bddd5f1c23'
end

class Flask < Formula
  url 'https://pypi.python.org/packages/source/F/Flask/Flask-0.10.1.tar.gz'
  sha1 'd3d078262b053f4438e2ed3fd6f9b923c2c92172'
end

class Lxml < Formula
  url 'https://pypi.python.org/packages/source/l/lxml/lxml-3.2.3.tar.gz'
  sha1 '33a3017090903f13b329ef3d81b5082e8d6463f7'
end

class Netlib < Formula
  url 'https://pypi.python.org/packages/source/n/netlib/netlib-0.9.2.tar.gz'
  sha1 '7c62c96829295d8e55f8644f242959f6a150720e'
end

class PyAsn1 < Formula
  url 'https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.7.tar.gz'
  sha1 'e32b91c5a5d9609fb1d07d8685a884bab22ca6d0'
end

class Urwid < Formula
  url 'https://pypi.python.org/packages/source/u/urwid/urwid-1.1.1.tar.gz'
  sha1 '0d6aa34975bb516565cfbf951487d26161e400b7'
end

class Mitmproxy < Formula
  homepage 'http://mitmproxy.org'
  url 'http://mitmproxy.org/download/mitmproxy-0.9.2.tar.gz'
  sha1 '7fa95ef27a4ac5ec85010f4ddb85cf6b7f17ef27'

  depends_on :python

  # TODO: Move this into Library/Homebrew somewhere (see also ansible.rb).
  def wrap bin_file, pythonpath
    bin_file = Pathname.new bin_file
    libexec_bin = Pathname.new libexec/'bin'
    libexec_bin.mkpath
    mv bin_file, libexec_bin
    bin_file.write <<-EOS.undent
      #!/bin/sh
      PYTHONPATH="#{pythonpath}:$PYTHONPATH" "#{libexec_bin}/#{bin_file.basename}" "$@"
    EOS
  end

  def install
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    python do
      PyOpenSsl.new.brew { system python, *install_args }
      Pil.new.brew { system python, *install_args }
      Flask.new.brew { system python, *install_args }
      Lxml.new.brew { system python, *install_args }
      Netlib.new.brew { system python, *install_args }
      PyAsn1.new.brew { system python, *install_args }
      Urwid.new.brew { system python, *install_args }

      inreplace 'libmproxy/__init__.py',
                /^$/,
                "import site; site.addsitedir('#{python.private_site_packages}')"

      system python, "setup.py", "install", "--prefix=#{prefix}"
    end

    Dir["#{bin}/*"].each do |bin_file|
      wrap bin_file, python.site_packages
    end
  end
end
