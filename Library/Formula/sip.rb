require 'formula'

# NOTE this should be provided by pip eventually
# currently easy_install doesn't seem to support it

class Sip <Formula
  url 'http://www.riverbankcomputing.co.uk/static/Downloads/sip4/sip-4.10.2.tar.gz'
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'
  md5 '52d11ca9c1a0d0cddc9b89268bff5929'

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
