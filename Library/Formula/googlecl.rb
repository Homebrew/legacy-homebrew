require 'formula'

class Googlecl < Formula
  homepage 'https://code.google.com/p/googlecl/'
  url 'https://googlecl.googlecode.com/files/googlecl-0.9.14.tar.gz'
  sha1 '810b2426e2c5e5292e507837ea425e66f4949a1d'

  depends_on :python

  conflicts_with 'osxutils', :because => 'both install a google binary'

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
    inreplace 'src/googlecl/__init__.py',
              "__author__ = 'tom.h.miller@gmail.com (Tom Miller)'",
              "__author__ = 'tom.h.miller@gmail.com (Tom Miller)'; import site; site.addsitedir('#{python.private_site_packages}')"

    system python, "setup.py", "install",
                   "--prefix=#{prefix}",
                   "--single-version-externally-managed",
                   "--record=installed.txt"

    wrap "#{bin}/google", python.site_packages
  end

  test do
    system "#{bin}/google", '--version'
  end
end
