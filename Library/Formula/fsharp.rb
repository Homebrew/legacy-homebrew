require "formula"

class Fsharp < Formula
  homepage "http://fsharp.org/"
  url "https://github.com/fsharp/fsharp.git", :tag => "3.1.1.25"

  bottle do
    sha1 "099b7e8179570aca78ab427a8d8ce25e0b3f0cd6" => :mavericks
    sha1 "604de51dfc12d77aa958f6de6a755956393a435b" => :mountain_lion
    sha1 "d6e907d4d37e85bdcad3fa50e53dde07839f0e6e" => :lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "mono"

  def install
    system "./autogen.sh", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    test_str = "Hello Homebrew"
    # fsharpi and fsharpc needs mono to be in the PATH
    ENV.prepend_path 'PATH', Formula["mono"].bin

    output = `echo 'printfn "#{test_str}"; exit 0' | #{bin}/fsharpi`
    assert $?.success?
    assert output.include? test_str

    hello = (testpath/"hello.fs")
    hello.write("printfn \"#{test_str}\"\n")
    `#{bin}/fsharpc #{hello}`
    assert $?.success?
    # make sure to find the fsharp assemblies even if the user has not set
    # MONO_GAC_PREFIX to HOMEBREW_PREFIX
    ENV["MONO_GAC_PREFIX"] = prefix
    output = `#{Formula["mono"].bin}/mono hello.exe`
    assert $?.success?
    assert_equal test_str, output.strip
  end

  def caveats; <<-EOS.undent
    To run programs built with fsharpc you need to set:
      export MONO_GAC_PREFIX="#{HOMEBREW_PREFIX}"
    EOS
  end
end
