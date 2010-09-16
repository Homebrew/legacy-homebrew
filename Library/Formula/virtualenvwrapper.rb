require 'formula'

class Virtualenvwrapper <Formula
  url 'http://www.doughellmann.com/downloads/virtualenvwrapper-2.2.1.tar.gz'
  homepage 'http://www.doughellmann.com/projects/virtualenvwrapper/'
  md5 '2a221f0a0d6df3267b69073013949310'

  def install
    libexec.install ['virtualenvwrapper.sh', 'virtualenvwrapper']
    # HACK: Make the wrapper exectuable, so `which` can find it.
    chmod 0755, libexec+'virtualenvwrapper.sh'

    bin.mkpath
    ln_s libexec+'virtualenvwrapper.sh', bin
  end

  def caveats
    <<-EOS.undent
      This project depends on "virtualenv" which is installed separately. See:
        http://pypi.python.org/pypi/virtualenv

      From the project homepage:
        1. Create a directory to hold all of the virtual environments.
           The default is $HOME/.virtualenvs

        2. Add two lines to your .bashrc to set the location where the
           virtual environments should live and the location of the
           script installed with this package:

            export WORKON_HOME=$HOME/.virtualenvs
            source #{HOMEBREW_PREFIX}/bin/virtualenvwrapper.sh

        3. Run: source ~/.bashrc

      Note that we did not install anything to your Python's site-packages.
      If you want to write extensions you may need to add:
        #{libexec}
      to your PYTHON_PATH.
    EOS
  end
end
