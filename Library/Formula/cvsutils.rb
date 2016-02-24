class Cvsutils < Formula
  desc "CVS utilities for use in working directories"
  homepage "http://www.red-bean.com/cvsutils/"
  url "http://www.red-bean.com/cvsutils/releases/cvsutils-0.2.6.tar.gz"
  sha256 "174bb632c4ed812a57225a73ecab5293fcbab0368c454d113bf3c039722695bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8e35c8b0ed2db868e7dd12f653c20d7d2709059fb5a773fd49084a2655f4ca0" => :el_capitan
    sha256 "ccefce4b4a1053e9a32e4f43318c7bf73c7154f0bee1be1cf1777e8fd3e8eabf" => :yosemite
    sha256 "ab6140058099bdc798e0e294640504035d5c976a8752742044a161c416e2e31e" => :mavericks
    sha256 "b30e0da765a551698ec56c09750842bf93e1db4c6596d2a741670aa5ce616c3a" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cvsu", "--help"
  end
end
