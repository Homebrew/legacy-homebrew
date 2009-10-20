require 'formula'

class Pip <Formula
  url 'http://pypi.python.org/packages/source/p/pip/pip-0.6.1.tar.gz'
  homepage 'http://pip.openplans.org/'
  md5 '7560e3055c66afb99ac4a7892389a237'

  depends_on 'setuptools'

  def install
    dest = "#{prefix}/lib/pip"
    system "python", "setup.py", "install", "--prefix=#{prefix}",
                                            "--install-purelib=#{dest}"
    # make sure we use the right python (distutils rewrites the shebang)
    # also adds the pip lib path to the PYTHONPATH
    script = DATA.read
    script.sub! "HOMEBREW_PIP_PATH", dest
    (bin+'pip').unlink
    (bin+'pip').write script
  end

  def caveats
    "pip installs packages. Python packages.\n"+
    "Run 'pip help' to see a list of commands."
  end
end

__END__
#!/usr/bin/env python
"""
This is the Homebrew pip wrapper
"""
import sys
sys.path.insert(0, 'HOMEBREW_PIP_PATH')
from pip import main

if __name__ == '__main__':
    main()