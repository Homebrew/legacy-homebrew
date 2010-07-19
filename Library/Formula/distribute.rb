require 'formula'

class Distribute <Formula
  url 'http://pypi.python.org/packages/source/d/distribute/distribute-0.6.14.tar.gz'
  homepage 'http://pypi.python.org/pypi/distribute/0.6.14'
  md5 'ac607e05682116c06383b27a15e2db90'

  def caveats
    <<-EOS.undent
      This formula is only meant to be used against a Homebrew-built Python.
      It will install itself directly into Python's location in the Cellar.
    EOS
  end

  def install
    python = Formula.factory("python")
    unless python.installed?
      onoe "The Distribute brew is only meant to be used against a Homebrew-built Python."
      puts <<-EOS
        Homebrew's "distribute" formula is only meant to be installed against a Homebrew-
        built version of Python, but we couldn't find such a version.

        The system-provided Python comes with "easy_install" already installed, with the
        caveat that some Python packages don't install cleanly against Apple's customized
        versions of Python.

        To install distribute against a custom Python, download distribute from:
          http://pypi.python.org/pypi/distribute
        unzip, and run:
          /path/to/custom/python setup.py install
      EOS
      exit 99
    end

    system "#{python.bin}/python", "setup.py", "install",
              "--install-scripts", bin,
              "--install-purelib", python.site_packages,
              "--install-platlib", python.site_packages

    (prefix+"README.homebrew").write <<-EOF
distribute's libraries were installed directly into:
  #{python.site_packages}
EOF
  end
end
