require 'formula'

class Sip <Formula
  url 'http://www.riverbankcomputing.co.uk/hg/sip/archive/4.11.1.tar.gz'
  md5 'dbafd7101a4e7caee6f529912a1356e5'
  head 'http://www.riverbankcomputing.co.uk/hg/sip', :using => :hg
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'

  def install
    # Force building against System python, because we need a Framework build.
    # See: http://github.com/mxcl/homebrew/issues/issue/930
    system "/usr/bin/python", "build.py", "prepare"
    system "/usr/bin/python", "configure.py",
                              "--destdir=#{lib}/python",
                              "--bindir=#{bin}",
                              "--incdir=#{include}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    This formula won't function until you amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/python:$PYTHONPATH
    EOS
  end
end
