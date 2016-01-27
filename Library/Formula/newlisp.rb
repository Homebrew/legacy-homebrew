class Newlisp < Formula
  desc "Lisp-like, general-purpose scripting language"
  homepage "http://www.newlisp.org/"
  url "http://www.newlisp.org/downloads/newlisp-10.7.0.tgz"
  sha256 "c4963bf32d67eef7e4957f7118632a0c40350fd0e28064bce095865b383137bb"

  bottle do
    revision 1
    sha256 "1cf0154b6a3728dc66321cafd346edbf068401de9ab132fedcaa25175633ec71" => :el_capitan
    sha256 "f90c42e44fa55f29339f0136006abbf8357720d3a0983ffcde9c73f04ad03e77" => :yosemite
    sha256 "1f99334ef4a7f02f046a6f748b763b266a742a838cf4079d89ed3caf5801af7d" => :mavericks
  end

  depends_on "readline" => :recommended

  def install
    # Required to use our configuration
    ENV.append_to_cflags "-DNEWCONFIG -c"

    # fix the prefix in a source file
    inreplace "guiserver/newlisp-edit.lsp", "#!/usr/local/bin/newlisp", "#!/usr/bin/env newlisp"
    inreplace "guiserver/newlisp-edit.lsp", "/usr/local/bin/newlisp", "#{opt_bin}/newlisp"

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
