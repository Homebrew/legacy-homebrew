class Sdf < Formula
  desc "Syntax Definition Formalism: high-level description of grammars"
  homepage "http://strategoxt.org/Sdf/WebHome"
  url "http://www.meta-environment.org/releases/sdf-2.6.3.tar.gz"
  sha256 "181ae979118d75c6163f2acec8e455952f3033378a4518b0b829d26a96e10b3d"

  bottle do
    sha256 "fd6d28045077329bfa7a65db2d70a21e5d5b36168deba4b54ec053f2e5af7168" => :mavericks
    sha256 "52088515427e70bb3f4f5602476d03508c93d8e8be266b170c18dbd1aa49198f" => :mountain_lion
    sha256 "1abf4584e65dbfab2fb42c857bcff3879f8db8764dd9c64bcf844fae8485bfe0" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "aterm"

  fails_with :clang do
    build 425
    cause <<-EOS.undent
      ParsedError.c:15434:611: fatal error: parser recursion
      limit reached, program too complex
    EOS
  end

  resource "c-library" do
    url "http://www.meta-environment.org/releases/c-library-1.2.tar.gz"
    sha256 "08fdec0faf3c941203ff3decaf518117f49f62a42b111bac39d88e62c453b066"
  end

  resource "toolbuslib" do
    url "http://www.meta-environment.org/releases/toolbuslib-1.1.tar.gz"
    sha256 "20f3d55b71b1e1ccf52b62e705a7dd7097ede764885d7ffd1030d27342069838"
  end

  resource "error-support" do
    url "http://www.meta-environment.org/releases/error-support-1.6.tar.gz"
    sha256 "634c0a1b5da8ef3b277d785d5df458dd7526da79aedd7d0537678204731dbc69"
  end

  resource "pt-support" do
    url "http://www.meta-environment.org/releases/pt-support-2.4.tar.gz"
    sha256 "85c8702cc96941f4190e01ceb6cf0ba61f8bc00cedd3776f01e6bc5c21847992"
  end

  resource "sdf-support" do
    url "http://www.meta-environment.org/releases/sdf-support-2.5.tar.gz"
    sha256 "40b324d4a20f31cc4e2393fb8009125a2307d10a2ba1017ac30fd5ed859e5f7d"
  end

  resource "asf-support" do
    url "http://www.meta-environment.org/releases/asf-support-1.8.tar.gz"
    sha256 "cc42fe4245b12f1ca8bcc69a36963dca4145ed6474279d89881ae0a65c7ec711"
  end

  resource "tide-support" do
    url "http://www.meta-environment.org/releases/tide-support-1.3.1.tar.gz"
    sha256 "4bd8228fee08f84332ab6d5e2cc7dae26ddcdf92c924d477864d48066306c81a"
  end

  resource "rstore-support" do
    url "http://www.meta-environment.org/releases/rstore-support-1.0.tar.gz"
    sha256 "86bc1fa5b83718255f5f7a40b83c62f73dbbf614cb21f05df551b57548c25039"
  end

  resource "config-support" do
    url "http://www.meta-environment.org/releases/config-support-1.4.tar.gz"
    sha256 "b1e6e696a4a3318c6cd688291dbb9b543d68f54196df71bca6530173f661904e"
  end

  resource "ptable-support" do
    url "http://www.meta-environment.org/releases/ptable-support-1.2.tar.gz"
    sha256 "c9d219a477392e8ee7b08c2e51195190fe5c4c195e5b2cb0c13bb91a750f1d2f"
  end

  resource "sglr" do
    url "http://www.meta-environment.org/releases/sglr-4.5.3.tar.gz"
    sha256 "e748695bb97c7954da0279a2ec8d871bd810b403002c3307e4229a2cc64c78cc"
  end

  resource "asc-support" do
    url "http://www.meta-environment.org/releases/asc-support-2.6.tar.gz"
    sha256 "acf5f93374d348e9aeba9590cb70392c199d2c031a6bb45d93d5f636911978eb"
  end

  resource "pgen" do
    url "http://www.meta-environment.org/releases/pgen-2.8.1.tar.gz"
    sha256 "8140d07d7512a7e963d16325427f8acaecc1dd12a23ef67593629cab6d36bd7c"
  end

  resource "pandora" do
    url "http://www.meta-environment.org/releases/pandora-1.6.tar.gz"
    sha256 "d62156efc4c2a921da9e1390423c72416f1d65e2ce0c97b9fbd372e51c2df28a"
  end

  def install
    ENV.j1 # build is not parallel-safe
    ENV.append "CFLAGS", "-std=gnu89 -fbracket-depth=1024" if ENV.compiler == :clang

    resource("c-library").stage do
      system "./configure", "--prefix=#{libexec}/c-library"
      system "make", "install"
    end

    resource("toolbuslib").stage do
      system "./configure", "--prefix=#{libexec}/toolbuslib"
      system "make", "install"
    end

    resource("error-support").stage do
      system "./configure", "--prefix=#{libexec}/error-support",
                            "--with-toolbuslib=#{libexec}/toolbuslib"
      system "make", "install"
    end

    resource("pt-support").stage do
      system "./configure", "--prefix=#{libexec}/pt-support",
                            "--with-toolbuslib=#{libexec}/toolbuslib",
                            "--with-error-support=#{libexec}/error-support"
      system "make", "install"
    end

    resource("sdf-support").stage do
      system "./configure", "--prefix=#{libexec}/sdf-support",
                            "--with-toolbuslib=#{libexec}/toolbuslib",
                            "--with-error-support=#{libexec}/error-support",
                            "--with-pt-support=#{libexec}/pt-support"
      system "make", "install"
    end

    resource("asf-support").stage do
      system "./configure", "--prefix=#{libexec}/asf-support",
                            "--with-error-support=#{libexec}/error-support",
                            "--with-pt-support=#{libexec}/pt-support"
      system "make", "install"
    end

    resource("tide-support").stage do
      system "./configure", "--prefix=#{libexec}/tide-support",
                            "--with-toolbuslib=#{libexec}/toolbuslib"
      system "make", "install"
    end

    resource("rstore-support").stage do
      system "./configure", "--prefix=#{libexec}/rstore-support",
                            "--with-toolbuslib=#{libexec}/toolbuslib"
      system "make", "install"
    end

    resource("config-support").stage do
      system "./configure", "--prefix=#{libexec}/config-support"
      system "make", "install"
    end

    resource("ptable-support").stage do
      system "./configure", "--prefix=#{libexec}/ptable-support",
                            "--with-pt-support=#{libexec}/pt-support"
      system "make", "install"
    end

    resource("sglr").stage do
      system "./configure", "--prefix=#{libexec}/sglr",
                            "--with-toolbuslib=#{libexec}/toolbuslib",
                            "--with-error-support=#{libexec}/error-support",
                            "--with-pt-support=#{libexec}/pt-support",
                            "--with-ptable-support=#{libexec}/ptable-support",
                            "--with-config-support=#{libexec}/config-support",
                            "--with-c-library=#{libexec}/c-library"
      system "make", "install"
    end

    resource("asc-support").stage do
      system "./configure", "--prefix=#{libexec}/asc-support",
                            "--with-toolbuslib=#{libexec}/toolbuslib",
                            "--with-error-support=#{libexec}/error-support",
                            "--with-pt-support=#{libexec}/pt-support",
                            "--with-ptable-support=#{libexec}/ptable-support",
                            "--with-config-support=#{libexec}/config-support",
                            "--with-c-library=#{libexec}/c-library",
                            "--with-tide-support=#{libexec}/tide-support",
                            "--with-rstore-support=#{libexec}/rstore-support",
                            "--with-asf-support=#{libexec}/asf-support",
                            "--with-rstore-support=#{libexec}/rstore-support",
                            "--with-sglr=#{libexec}/sglr"
      system "make", "install"
    end

    resource("pgen").stage do
      system "./configure", "--prefix=#{libexec}/pgen",
                            "--with-toolbuslib=#{libexec}/toolbuslib",
                            "--with-error-support=#{libexec}/error-support",
                            "--with-pt-support=#{libexec}/pt-support",
                            "--with-ptable-support=#{libexec}/ptable-support",
                            "--with-config-support=#{libexec}/config-support",
                            "--with-c-library=#{libexec}/c-library",
                            "--with-sglr=#{libexec}/sglr",
                            "--with-sdf-support=#{libexec}/sdf-support",
                            "--with-asc-support=#{libexec}/asc-support"
      system "make", "install"
    end

    resource("pandora").stage do
      system "./configure", "--prefix=#{libexec}/pandora",
                            "--with-toolbuslib=#{libexec}/toolbuslib",
                            "--with-pt-support=#{libexec}/pt-support",
                            "--with-asc-support=#{libexec}/asc-support"
      system "make", "install"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--with-sglr=#{libexec}/sglr",
                          "--with-pgen=#{libexec}/pgen",
                          "--with-pandora=#{libexec}/pandora"
    system "make", "install"
  end
end
