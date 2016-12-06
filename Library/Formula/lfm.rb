require 'formula'

class Lfm < Formula
  homepage 'http://code.google.com/p/lfm/'
  url 'http://lfm.googlecode.com/files/lfm-2.3.tar.gz'
  sha1 'a751c7e71bb5a3d5442c7696a01348658cde58a6'

  depends_on :python

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
      inreplace 'lfm/__init__.py',
                "import locale",
                "import locale; import site; site.addsitedir('#{python.private_site_packages}')"

      system python, "setup.py", "install", "--prefix=#{prefix}"
    end

    Dir["#{bin}/*"].each do |bin_file|
      wrap bin_file, python.site_packages
    end
  end
end

