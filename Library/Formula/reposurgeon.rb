class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "http://www.catb.org/~esr/reposurgeon/reposurgeon-3.29.tar.xz"
  sha256 "51105e18a2f350146e23c01ea559a07400c3b715f8ec338206f19c19197b0a0f"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any
    sha256 "ebb4814ee867bf1dcef371b24b7ee678ee0047cdee8051253d46a887ccdda4be" => :yosemite
    sha256 "2ff04b1a906524331c7c40270b0c7ffcd01fbe18a22b714726f1cb818e7af864" => :mavericks
    sha256 "0485707cc564f06070a9048a4cc893ef7a8e45130d6482dc3a432c3bbbcace34" => :mountain_lion
  end

  option "without-cython", "Build without cython (faster compile)"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build

  resource "cython" do
    url "http://cython.org/release/Cython-0.23.1.tar.gz"
    sha256 "bdfd12d6a2a2e34b9a1bbc1af5a772cabdeedc3851703d249a52dcda8378018a"
  end

  def install
    # OSX doesn't provide 'python2', but on some Linux distributions
    # 'python' is an alias for python3 so this won't be changed
    # upstream
    %W[reposurgeon repodiffer].each do |file|
      inreplace file, "#!/usr/bin/env python2", "#!/usr/bin/env python"
    end

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
    touch "homebrew"
    system "git", "add", "homebrew"
    system "git", "commit", "--message", "brewing"

    assertion = lambda do |prog|
      assert_match "brewing", shell_output("script -q /dev/null #{bin}/#{prog} read list")
    end
    assertion["reposurgeon"]
    assertion["cyreposurgeon"] if build.with? "cython"
  end
end
