require 'formula'

class LabJackPython <Formula
  url  'http://github.com/labjack/LabJackPython/tarball/9-20-2010'
  md5  '2486b758b1cceddb1f565d839e2ac60e'
  version '2010-09-20'
  homepage 'http://labjack.com/support/labjackpython'
  head 'http://github.com/labjack/LabJackPython.git', :using => :git

  depends_on 'exodriver'

  def caveats
    <<-EOS.undent
      If you are using a non-Homebrew-built Python, you may need to add:
        #{HOMEBREW_PREFIX}/lib/pythonX.Y/site-packages
      to your PYTHONPATH, where "X.Y" was the version of Python this
      formula was built against.
    EOS
  end

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end
end