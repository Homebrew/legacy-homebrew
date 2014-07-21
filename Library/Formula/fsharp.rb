require "formula"

class Fsharp < Formula
  homepage "http://fsharp.org/"
  url "https://github.com/fsharp/fsharp.git", :tag => "3.1.1.6"

  bottle do
    sha1 "df3f509b0d91c6341c4b082fca8a117686ec2fd4" => :mavericks
    sha1 "7c362e7ae8b8bfa47544555c6497652bd9b964a3" => :mountain_lion
    sha1 "5ba51de580838a3e365d1d6e16dc7f4804089665" => :lion
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
