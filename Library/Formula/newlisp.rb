class Newlisp < Formula
  desc "Lisp-like, general-purpose scripting language"
  homepage "http://www.newlisp.org/"
  url "http://www.newlisp.org/downloads/newlisp-10.7.0.tgz"
  sha256 "c4963bf32d67eef7e4957f7118632a0c40350fd0e28064bce095865b383137bb"

  bottle do
    sha256 "8bc10b849d0a5452a2cf6de53cd7eb6d3df97ca4369e8a3eb28eff82953ca2bb" => :el_capitan
    sha256 "29cf459d873290b0876cb798cb06dfe1df51db10da9f6300e04f1e9d7d7aecb8" => :yosemite
    sha256 "dbacba90228024041cbe50efc63959cdaa94c3ca0d30267bcedcd1769dc4c597" => :mavericks
  end

  depends_on "readline" => :recommended

  def install
    # Required to use our configuration
    ENV.append_to_cflags "-DNEWCONFIG -c"

    # fix the prefix in a source file
    inreplace "guiserver/newlisp-edit.lsp" do |s|
      s.gsub! "#!/usr/local/bin/newlisp", "#!/usr/bin/env newlisp"
      s.gsub! "/usr/local/bin/newlisp", "#{opt_bin}/newlisp"
    end

    system "./configure-alt", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    If you have brew in a custom prefix, the included examples
    will need to be be pointed to your newlisp executable.
    EOS
  end

  test do
    path = testpath/"test.lsp"
    path.write <<-EOS
      (println "hello")
      (exit 0)
    EOS

    assert_equal "hello\n", shell_output("#{bin}/newlisp #{path}")
  end
end
