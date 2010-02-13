require 'formula'

class Pip <Formula
  url 'http://pypi.python.org/packages/source/p/pip/pip-0.6.3.tar.gz'
  homepage 'http://pip.openplans.org/'
  md5 '0602fa9179cfaa98e41565d4a581d98c'

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

  def two_line_instructions
    "pip installs packages. Python packages.\n"+
    "Run 'pip help' to see a list of commands."
  end

  # http://github.com/mxcl/homebrew/issues/issue/711
  def caveats
    cfg = '~/.pydistutils.cfg'
    "pip will break unless you delete your #{cfg} file!" if File.exist?(File.expand_path(cfg))
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