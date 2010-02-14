require 'formula'

class Pip <Formula
  url 'http://pypi.python.org/packages/source/p/pip/pip-0.6.3.tar.gz'
  homepage 'http://pip.openplans.org/'
  md5 '0602fa9179cfaa98e41565d4a581d98c'

  depends_on 'setuptools'

  def install
    dest = prefix+"lib/pip"

    # make sure we use the right python (distutils rewrites the shebang)
    # also adds the pip lib path to the PYTHONPATH
    (bin+'pip').write(DATA.read.sub("HOMEBREW_PIP_PATH", dest))

    # FIXME? If we use /usr/bin/env python in the pip script
    # then should we be hardcoding this version? I dunno.
    python_version = `python -V 2>&1`.match('Python (\d+\.\d+)').captures.at(0)

    dest.install('pip')
    cp 'pip.egg-info/PKG-INFO', "#{dest}/pip-#{version}-py#{python_version}.egg-info"
  end

  def two_line_instructions
    "pip installs packages. Python packages.\n"+
    "Run 'pip help' to see a list of commands."
  end

  def caveats
    # I'm going to add a proper two_line_instructions formula function at some point
    two_line_instructions
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