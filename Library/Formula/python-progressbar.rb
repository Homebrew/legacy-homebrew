require 'formula'

class PythonProgressbar < Formula
  url 'https://python-progressbar.googlecode.com/files/progressbar-2.3.tar.gz'
  homepage ''
  md5 '4f904e94b783b4c6e71aa74fd2432c59'

  def install
	system "python setup.py config"
	system "python setup.py install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test progressbar`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
