require 'formula'

class Fann < Formula
  url 'http://downloads.sourceforge.net/project/fann/fann/2.1.0beta/fann-2.1.0beta.zip'
  homepage 'http://leenissen.dk/fann'
  version '2.1.0beta'
  md5 '9c53d96ce415c927cb97b8f9de2ea881'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
           "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
