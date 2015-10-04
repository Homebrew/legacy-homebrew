class Fsharp < Formula
  desc "F#, a functional-first programming language"
  homepage "http://fsharp.org/"
  url "https://github.com/fsharp/fsharp.git", :tag => "3.1.2.4",
                                              :revision => "8d02a54a75de362d6b649dcaaacfefe6db9caf41"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "97589b3e7d5ffa745bca99bd9af8b22bc235201533b4a0eaf837735d58ef322b" => :el_capitan
    sha256 "dcbb1135359e72ffdb76ce40a5b75bcea3e78083f56eb01c56186d007f37a3ce" => :yosemite
    sha256 "3d2ccce2f75a68cef19427407b4dc4bb4865bcfe1e7843810013f6fea07728a7" => :mavericks
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

  def post_install
    mono_ver = Formula["mono"].version
    %w[3.0 3.1].each do |fsharp_ver|
      %w[Microsoft.Portable.FSharp.Targets
         Microsoft.FSharp.Targets].each do |fsharp_targ|
        tree_dir   = "lib/mono/Microsoft\ SDKs/F\#/#{fsharp_ver}/Framework/v4.0"
        source_dir = File.expand_path "#{prefix}/../../mono/#{mono_ver}/#{tree_dir}"

        # variables:
        #  - tree_dir: the 'convoluted' non-absolute path the the installation, inside mono's prefix
        #  - source_dir: tree_dir, inside mono's prefix, expanded to a full path
        #  - fsharp_targ: the target file (for xbuild)
        mkdir_p source_dir
        ln_sf "#{prefix}/#{tree_dir}/#{fsharp_targ}", "#{source_dir}/#{fsharp_targ}"
      end
    end
  end

  test do
    test_str = "Hello Homebrew"
    # fsharpi and fsharpc needs mono to be in the PATH
    ENV.prepend_path "PATH", Formula["mono"].bin

    output = shell_output %(echo 'printfn "#{test_str}"; exit 0' | #{bin}/fsharpi)
    assert output.include? test_str

    hello = (testpath/"hello.fs")
    hello.write("printfn \"#{test_str}\"\n")
    compiler_output = shell_output "#{bin}/fsharpc #{hello}"
    # make sure to find the fsharp assemblies even if the user has not set
    # MONO_GAC_PREFIX to HOMEBREW_PREFIX
    ENV["MONO_GAC_PREFIX"] = prefix
    output = shell_output "#{Formula["mono"].bin}/mono hello.exe"
    assert_match test_str, output.strip
  end

  def caveats; <<-EOS.undent
    To run programs built with fsharpc you need to set:
      export MONO_GAC_PREFIX="#{HOMEBREW_PREFIX}"
    EOS
  end
end
