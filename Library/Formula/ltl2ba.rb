require "formula"

class Ltl2ba < Formula
  homepage "http://www.lsv.ens-cachan.fr/~gastin/ltl2ba/"
  url "http://www.lsv.ens-cachan.fr/~gastin/ltl2ba/ltl2ba-1.2b1.tar.gz"
  sha1 "74cff4914203753544bf300e041f433dbaeb3289"

  def install
    system "make"
    bin.install "ltl2ba"
  end
end
