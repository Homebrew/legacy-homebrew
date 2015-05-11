class Rancid < Formula
  homepage "http://www.shrubbery.net/rancid/"
  url "ftp://ftp.shrubbery.net/pub/rancid/rancid-3.2.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/r/rancid/rancid_3.2.orig.tar.gz"
  sha256 "e7da7242c1f072700b8d6077314be91c1fabe62528de2bdf91349b7094729e75"

  bottle do
    sha1 "837224d076cccb23bc1d3891021e3e4fb9dfd791" => :yosemite
    sha1 "2b58d8cedb8e78e38259751374b8e047b62812b9" => :mavericks
    sha1 "e8eceee0e238a220231f4227e45ed25567212e4e" => :mountain_lion
  end

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
