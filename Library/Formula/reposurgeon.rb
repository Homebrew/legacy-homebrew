class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "http://www.catb.org/~esr/reposurgeon/reposurgeon-3.27.tar.gz"
  sha256 "e2c0563384fa29917bb5014214280e586dbe389edd0c7006a3cdecb63c7b2e85"
  revision 1

  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any
    sha256 "863b3841ed6015be8d5c7fe8888cf63b08746c9134efd8ca220162b45eb16540" => :yosemite
    sha256 "8b4c2487585b98d638a7361fa4243f1c8b400703dafeb73c5bdb6907668f6da7" => :mavericks
    sha256 "47da8b218eda27df5a1ec36774475060d41708eb4e9ecd3071458e89ea445fba" => :mountain_lion
  end

  option "without-cython", "Don't build a significantly faster tool using cython"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build

  resource "cython" do
    url "http://cython.org/release/Cython-0.22.1.tar.gz"
    sha256 "7fff120e65e7b66edb4a42823f5642bad3bc1e5601bf882d66aee50248cf0682"
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
    (share/"emacs/site-lisp").install "reposurgeon-mode.el"

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

    assertion = lambda do |prog|
      assert_match "brewing", shell_output("script -q /dev/null #{bin}/#{prog} read list")
    end
    assertion["reposurgeon"]
    assertion["cyreposurgeon"] if build.with? "cython"
  end
end
