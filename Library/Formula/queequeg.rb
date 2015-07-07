require "formula"

class Queequeg < Formula
  desc "English grammar checker for non-native speakers"
  homepage "http://queequeg.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/queequeg/queequeg/queequeg-0.91/queequeg-0.91.tar.gz"
  sha1 "e0ceae717a297ee866e38ae7fd10c216df1232e9"

  bottle do
    cellar :any
    sha1 "865d487cdd7f447eee5cc102b2d5f79efdc1fb9e" => :yosemite
    sha1 "c088cb0e9a0ddc16c113fc8ff41446376d7f755c" => :mavericks
    sha1 "8cc2f12a1c395d8e1693f5ed6b37b94307968541" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "wordnet"

  def install
    system "make", "dict", "WORDNETDICT=#{Formula["wordnet"].opt_prefix}/dict"

    libexec.install "abstfilter.py", "constraint.py", "convdict.py",
                    "dictionary.py", "document.py",
                    "grammarerror.py", "markupbase_rev.py", "output.py",
                    "postagfix.py", "pstring.py", "qq", "regpat.py",
                    "sentence.py", "sgmllib_rev.py", "texparser.py",
                    "unification.py"

    if File.exist? "dict.cdb"
      libexec.install "dict.cdb"
    else
      libexec.install "dict.txt"
    end

    bin.write_exec_script "#{libexec}/qq"
  end

  test do
    (testpath/"filename").write "This is a test."
    system "#{bin}/qq", "#{testpath}/filename"
  end
end
