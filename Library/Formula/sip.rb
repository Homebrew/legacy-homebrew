require 'formula'

# Note: this project doesn't save old releases, so it breaks often as
# downloads disappear.

class Sip <Formula
  url 'http://www.riverbankcomputing.co.uk/static/Downloads/sip4/sip-4.10.3.tar.gz'
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'
  md5 'cb0922b5d12add2d36061e43be64f5ce'

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
