class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "http://www.catb.org/~esr/reposurgeon/reposurgeon-3.33.tar.xz"
  sha256 "88a88d8fa0f612f5efc7ba5b2ca741713d260a250ada5b1ee01029436c08b571"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any
    sha256 "afe3bcd343cfe1897e9951720feef41037de0dd2abb2799747956f98c2930cbb" => :yosemite
    sha256 "bac28e15ce2610589c4adc6a8b40327843fbdbbf3081195fbfa8eb2bc9a17dbd" => :mavericks
    sha256 "a2b14e3135d25089933abf0bb28e79048d9788972636c70eadb30a37277e45fa" => :mountain_lion
  end

  option "without-cython", "Build without cython (faster compile)"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build

  resource "cython" do
    url "http://cython.org/release/Cython-0.23.4.tar.gz"
    sha256 "fec42fecee35d6cc02887f1eef4e4952c97402ed2800bfe41bbd9ed1a0730d8e"
  end

  def install
    # OSX doesn't provide 'python2', but on some Linux distributions
    # 'python' is an alias for python3 so this won't be changed
    # upstream
    inreplace %w[reposurgeon repodiffer],
      "#!/usr/bin/env python2", "#!/usr/bin/env python"

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make", "install", "prefix=#{prefix}"
    (share/"emacs/site-lisp/reposurgeon").install "reposurgeon-mode.el"

    if build.with? "cython"
      resource("cython").stage do
        system "python", *Language::Python.setup_install_args(buildpath/"vendor")
      end
      ENV.prepend_path "PYTHONPATH", buildpath/"vendor/lib/python2.7/site-packages"
      system "make", "install-cyreposurgeon", "prefix=#{prefix}",
             "CYTHON=#{buildpath}/vendor/bin/cython",
             "pyinclude=" + `python-config --cflags`.chomp,
             "pylib=" + `python-config --ldflags`.chomp
    end
  end

  test do
    (testpath/".gitconfig").write <<-EOS.undent
      [user]
        name = Real Person
        email = notacat@hotmail.cat
      EOS
    system "git", "init"
    system "git", "commit", "--allow-empty", "--message", "brewing"

    assert_match "brewing",
      shell_output("script -q /dev/null #{bin}/reposurgeon read list")
  end
end
