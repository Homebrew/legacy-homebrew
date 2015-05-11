class Reposurgeon < Formula
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "http://www.catb.org/~esr/reposurgeon/reposurgeon-3.21.tar.gz"
  sha256 "637f1450b235f0a08d6f850e565a60b357607ce3a95dcbaea15425947fd002b9"

  head "git://thyrsus.com/repositories/reposurgeon.git"

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build

  def install
    # OSX doesn't provide 'python2', but on some Linux distributions
    # 'python' is an alias for python3 so this won't be changed
    # upstream
    %W[reposurgeon repodiffer].each do |file|
      inreplace file, "#!/usr/bin/env python2", "#!/usr/bin/env python"
    end

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make", "install", "prefix=#{prefix}"
    (share/"emacs/site-lisp").install "reposurgeon-mode.el"
  end

  def caveats; <<-EOS.undent
    An Emacs mode has been installed in #{HOMEBREW_PREFIX}/share/emacs/site-lisp
    Add it to your load-path to use reposurgeon-mode.el
    EOS
  end

  test do
    (testpath/".gitconfig").write <<-EOS.undent
      [user]
        name = Real Person
        email = notacat@hotmail.cat
      EOS
    system "git", "init"
    touch "homebrew"
    system "git", "add", "homebrew"
    system "git", "commit", "--message", "brewing"

    assert_match "brewing", shell_output("script -q /dev/null #{bin}/reposurgeon read list")
  end
end
