require 'formula'

class Eric4 < Formula
  url 'http://sourceforge.net/projects/eric-ide/files/eric4/stable/4.4.14/eric4-4.4.14.tar.gz'
  homepage ''
  md5 'dc8d56fa68c0011633502fdc094fc04e'

  depends_on 'qscintilla2'

  def install
    system "python", "install.py", "-a", "#{prefix}/qsci", "-b", bin
  end

  def caveats
    "some files are installed into your python site-packages that will not be removed automatically by brew"
  end

end
