class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "http://www.catb.org/~esr/reposurgeon/reposurgeon-3.27.tar.gz"
  sha256 "e2c0563384fa29917bb5014214280e586dbe389edd0c7006a3cdecb63c7b2e85"

  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any
    sha256 "0f93e047fd0c6e3a29d30d7297cadc4dffb50482c46efd68a181bccd16cd596f" => :yosemite
    sha256 "637d175cc04890d4787dc49a526c8d5a50ef046b97ee07471e9d36d92d395a72" => :mavericks
    sha256 "6457aa5a0cb2dd9e89173992ea209a61bdc110b448291fbde376fc4ae64614fc" => :mountain_lion
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
