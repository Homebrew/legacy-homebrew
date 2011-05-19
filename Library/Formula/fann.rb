require 'formula'

class Fann < Formula
  url 'http://sourceforge.net/projects/fann/files/fann/2.1.0beta/fann-2.1.0beta.zip'
  homepage 'http://leenissen.dk/fann/wp/'
  md5 '9c53d96ce415c927cb97b8f9de2ea881'
  version '2.1.0beta'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
