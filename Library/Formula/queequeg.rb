class Queequeg < Formula
  desc "English grammar checker for non-native speakers"
  homepage "http://queequeg.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/queequeg/queequeg/queequeg-0.91/queequeg-0.91.tar.gz"
  sha256 "44e2f2bb8b68d08b7ee95ece24cefeeea8ec6ff9150851922015b73fc8908136"

  bottle do
    cellar :any
    sha256 "4b34b55b1e0686180a0b12b4d03a50d4b4a47aa63637cea6bcd8653b7bf4f39b" => :yosemite
    sha256 "8356dfd1ec596b87d62a5bc9df8a7574f8d85b06ccc6c55fcc5d1483676f9be1" => :mavericks
    sha256 "adc25d3e542a2d71924a1c2470fb86bed1eceb1938d259b4013fb8d36206e374" => :mountain_lion
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
