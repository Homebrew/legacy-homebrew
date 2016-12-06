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
  system "true"
  end
end
