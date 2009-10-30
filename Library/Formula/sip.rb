require 'formula'

class Sip <Formula
  url 'http://www.riverbankcomputing.co.uk/static/Downloads/sip4/sip-4.9.tar.gz'
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'
  md5 ''

  def install
    system "python", "./configure.py"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
