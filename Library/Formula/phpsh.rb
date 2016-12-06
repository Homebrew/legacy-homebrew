require 'formula'

class Phpsh <Formula
  head 'git://github.com/facebook/phpsh.git'
  homepage 'http://www.phpsh.org/'

  def install
    system "python", "setup.py", "build"
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  def caveats
    <<-EOS.undent
      If you are using built-in Python (not from Homebrew), you may need to add
        #{HOMEBREW_PREFIX}/lib/pythonX.Y/site-packages
      to your PYTHONPATH, where "X.Y" was the version of Python this formula was built against.
    EOS
  end
end
