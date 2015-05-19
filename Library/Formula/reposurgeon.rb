class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "http://www.catb.org/~esr/reposurgeon/reposurgeon-3.22.tar.gz"
  sha256 "66f366fc92d908fd68717cfb86eade989b7f550481b2e055803fd400805d1b14"

  head "git://thyrsus.com/repositories/reposurgeon.git"

  bottle do
    cellar :any
    sha256 "c5841c5c81cfbe2d19f0ff25fe5215b208fef8ef7c5676261ec50d539cbdc77e" => :yosemite
    sha256 "4d03f9193c74b126394c735698692891e90c0dc9e2c3f5e2bd96494f0905aefd" => :mavericks
    sha256 "7d61765e24830fd38e24163452866fda5d565f3ac52f3da8fa9b27a976d6eef1" => :mountain_lion
  end

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
