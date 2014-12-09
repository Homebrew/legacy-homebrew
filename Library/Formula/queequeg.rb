require "formula"

class Queequeg < Formula
  homepage "http://queequeg.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/queequeg/queequeg/queequeg-0.91/queequeg-0.91.tar.gz"
  sha1 "e0ceae717a297ee866e38ae7fd10c216df1232e9"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "wordnet"

  def install
    # Build the dictionary
    system "make", "dict", "WORDNETDICT=#{Formula["wordnet"].opt_prefix}/dict"

    # Install python files and dictionary into libexec
    install_list = ["abstfilter.py", "constraint.py", "convdict.py",
                    "dictionary.py", "document.py",
                    "grammarerror.py", "markupbase_rev.py", "output.py",
                    "postagfix.py", "pstring.py", "qq", "regpat.py",
                    "sentence.py", "sgmllib_rev.py", "texparser.py", "unification.py"]
    libexec.install install_list
    if File.exist? "dict.cdb"
      libexec.install "dict.cdb"
    else
      libexec.install "dict.txt"
    end
    # Write a wrapper for qq
    bin.write_exec_script "#{libexec}/qq"
  end

  test do
    (testpath/"filename").write "This is a test."
    system "#{bin}/qq", "#{testpath}/filename"
  end
end
