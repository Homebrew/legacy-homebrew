class Juman < Formula
  desc "Japanese morphological analysis system"
  homepage "http://nlp.ist.i.kyoto-u.ac.jp/index.php?JUMAN"
  url "http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/juman/juman-7.01.tar.bz2"
  sha256 "64bee311de19e6d9577d007bb55281e44299972637bd8a2a8bc2efbad2f917c6"

  bottle do
    sha256 "b2ccfe90011dead77ca0789cbdcdf30aa24e2ebcd3dd19c8d01b6adacbf7c816" => :yosemite
    sha256 "f959168856e884fcdadea2d19e9ebfa3ee6cdafb6e133588fce001de677fbe2a" => :mavericks
    sha256 "098a7ddfd7cd9524e34473c286465ef63864de21c4a23c91d449b1bd5272b090" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    result = `echo \xe4\xba\xac\xe9\x83\xbd\xe5\xa4\xa7\xe5\xad\xa6 | juman | md5`.chomp
    assert_equal "a5dd58c8ffa618649c5791f67149ab56", result
  end
end
