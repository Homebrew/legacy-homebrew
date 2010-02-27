require 'formula'

# NOTE this should be provided by pip eventually
# currently easy_install doesn't seem to support it

class Sip <Formula
  url 'http://www.riverbankcomputing.co.uk/static/Downloads/sip4/sip-4.10.tar.gz'
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'
  md5 '4b8f7361839b33868dd3cc576509ba8e'

  def install
    system "python", "configure.py", "--destdir=#{lib}/python",
                                     "--bindir=#{bin}",
                                     "--incdir=#{include}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    This formula won't function until you amend your PYTHONPATH like so:

        export PYTHON_PATH=#{HOMEBREW_PREFIX}/lib/python:$PYTHON_PATH

    This is why you would ideally install sip using pip or easy_install. But this
    can't work because this package doesn't support Python's disttools.
    EOS
  end
end
