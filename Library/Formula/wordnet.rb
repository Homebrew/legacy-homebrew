require 'formula'

class WordnetDictionaryUpdate < Formula
  homepage 'http://wordnet.princeton.edu/'
  url 'http://wordnetcode.princeton.edu/wn3.1.dict.tar.gz'
  sha1 '67dee39f6e83c9a05d98c5790722b807812cda87'
  version '3.1'
end

class Wordnet < Formula
  homepage 'http://wordnet.princeton.edu/'
  url 'http://wordnetcode.princeton.edu/3.0/WordNet-3.0.tar.bz2'
  sha1 'aeb7887cb4935756cf77deb1ea86973dff0e32fb'
  # Version 3.1 is version 3.0 with the 3.1 dictionary.
  version '3.1'

  depends_on :x11

  def install
    WordnetDictionaryUpdate.new.brew do
      (prefix+"dict").install Dir['*']
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    ENV.deparallelize
    system "make install"
  end
end
