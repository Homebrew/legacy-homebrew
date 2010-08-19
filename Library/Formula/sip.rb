require 'formula'

# Note: this project doesn't save old releases, so it breaks often as
# downloads disappear.

class Sip <Formula
  url 'http://www.riverbankcomputing.co.uk/static/Downloads/sip4/sip-4.10.5.tar.gz'
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'
  md5 '0a591ef6e59aa16e56822d3eb9fe21b8'

  def install
    # Force building against System python, because we need a Framework build.
    # See: http://github.com/mxcl/homebrew/issues/issue/930
    system "/usr/bin/python", "configure.py",
                              "--destdir=#{lib}/python",
                              "--bindir=#{bin}",
                              "--incdir=#{include}"
    system "make install"
  end

  def caveats; <<-EOS
This formula won't function until you amend your PYTHONPATH like so:
    export PYTHON_PATH=#{HOMEBREW_PREFIX}/lib/python:$PYTHON_PATH
EOS
  end
end
