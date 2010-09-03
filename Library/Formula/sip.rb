require 'formula'

# Note: this project doesn't save old releases, so it breaks often as
# downloads disappear.

class Sip <Formula
  url 'http://www.riverbankcomputing.co.uk/static/Downloads/sip4/sip-4.11.tar.gz'
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'
  md5 '810f0cb0da327e0120fd87b7194ddf7e'

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
    export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/python:$PYTHONPATH
EOS
  end
end
