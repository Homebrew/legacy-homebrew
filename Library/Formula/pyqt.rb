require 'formula'

# Note: this project doesn't save old releases, so it breaks often as
# downloads disappear.

class Pyqt <Formula
  url 'http://www.riverbankcomputing.co.uk/static/Downloads/PyQt4/PyQt-mac-gpl-4.8.tar.gz'
  homepage 'http://www.riverbankcomputing.co.uk/software/pyqt'
  md5 'e4423183a52081be05b7b658cd033731'

  depends_on 'sip'
  depends_on 'qt'

  def install
    ENV.prepend 'PYTHONPATH', "#{HOMEBREW_PREFIX}/lib/python", ':'

    # SIP gets built against system python, so PyQt should as well.
    system "/usr/bin/python", "./configure.py", "--confirm-license",
                                       "--bindir=#{bin}",
                                       "--destdir=#{lib}/python",
                                       "--sipdir=#{share}/sip"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS
This formula won't function until you amend your PYTHONPATH like so:
    export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/python:$PYTHONPATH
EOS
  end
end
