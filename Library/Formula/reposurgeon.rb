class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"

  stable do
    url "http://www.catb.org/~esr/reposurgeon/reposurgeon-3.28.tar.gz"
    sha256 "3225b44109b8630310a0ea6fe63a3485d27aa46deaf80e8d07820e01a6f62626"

    # Fixes https://gitlab.com/esr/reposurgeon/issues/17
    # Can be removed in next stable release
    patch do
      url "https://gitlab.com/esr/reposurgeon/commit/6cab1aa7c811ac11cd61e044e60ad6f160c1d8c1.diff"
      sha256 "8e067cb551f8a5f48c701f60a9c46e4ad9312a833f26fefde99f46b47e92cf77"
    end
  end

  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any
    sha256 "863b3841ed6015be8d5c7fe8888cf63b08746c9134efd8ca220162b45eb16540" => :yosemite
    sha256 "8b4c2487585b98d638a7361fa4243f1c8b400703dafeb73c5bdb6907668f6da7" => :mavericks
    sha256 "47da8b218eda27df5a1ec36774475060d41708eb4e9ecd3071458e89ea445fba" => :mountain_lion
  end

  option "without-cython", "Build without cython (faster compile)"

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
