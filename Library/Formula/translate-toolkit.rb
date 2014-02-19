require 'formula'

class TranslateToolkit < Formula
  homepage 'http://toolkit.translatehouse.org/'
  url 'http://downloads.sourceforge.net/project/translate/Translate%20Toolkit/1.11.0/translate-toolkit-1.11.0.tar.bz2'
  sha1 'c67d17f9c0a3a04e1d18e8e0eb4c2440a11ec5ab'

  def install
    bin.mkpath
    system "python", "setup.py", "install",
             "--prefix=#{prefix}",
             "--install-scripts=#{bin}",
             "--install-data=#{libexec}"
  end
end
