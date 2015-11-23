class Ltl2ba < Formula
  desc "Translate LTL formulae to Buchi automata"
  homepage "https://www.lsv.ens-cachan.fr/~gastin/ltl2ba/"
  url "https://www.lsv.ens-cachan.fr/~gastin/ltl2ba/ltl2ba-1.2b1.tar.gz"
  sha256 "950f304c364ffb567a4fba9b88f1853087c0dcf57161870b6314493fddb492b8"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "45916a60bb32849e1bc3709d019dcf6ac9d140d92e6f6b65bb5ca05de5c63e3b" => :el_capitan
    sha256 "d4c93b1f70b126540dae9d77e16f7e0b42e58ff1997fce63f51820621693588d" => :yosemite
    sha256 "75c0b88b4be2658bc02feb02214f833f7b27758381924b3e3a742ee9309579f6" => :mavericks
  end

  def install
    system "make"
    bin.install "ltl2ba"
  end
end
