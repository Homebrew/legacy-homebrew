class Rancid < Formula
  desc "Really Awesome New Cisco confIg Differ"
  homepage "http://www.shrubbery.net/rancid/"
  url "ftp://ftp.shrubbery.net/pub/rancid/rancid-3.2.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/r/rancid/rancid_3.2.orig.tar.gz"
  sha256 "e7da7242c1f072700b8d6077314be91c1fabe62528de2bdf91349b7094729e75"

  bottle do
    sha256 "361593d9d0604f9a82761737e7452aa26d5e9d82c7d14209ffdc1fb8e40c2ddb" => :yosemite
    sha256 "b58dfdca8ca5769648a3eec9f801bac32419185e2602043a1c7ee032de06da8c" => :mavericks
    sha256 "dc6eb5f1cec36fb614ba2dc1bfd5590b19d9b57aaac1a88d00c635af5f46b2ae" => :mountain_lion
  end

  conflicts_with "par", :because => "both install `par` binaries"

  def install
    system "./configure", "--prefix=#{prefix}", "--exec-prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"rancid.conf").write <<-EOS.undent
      BASEDIR=#{testpath}; export BASEDIR
      CVSROOT=$BASEDIR/CVS; export CVSROOT
      LOGDIR=$BASEDIR/logs; export LOGDIR
      RCSSYS=git; export RCSSYS
      LIST_OF_GROUPS="backbone aggregation switches"
    EOS
    system "#{bin}/rancid-cvs", "-f", testpath/"rancid.conf"
  end
end
