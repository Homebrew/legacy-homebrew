require "formula"

class Fsharp < Formula
  desc "F#, a functional-first programming language"
  homepage "http://fsharp.org/"
  url "https://github.com/fsharp/fsharp.git", :tag => "3.1.1.32",
    :revision => "a4e1f7111a6d1410df3f33e7205ee34617006b94"

  bottle do
    sha256 "10e035403f71f47b03e0961f5dc83959b5e2d8600a9af670e559bba811173ae9" => :yosemite
    sha256 "e19150b83bf8fcc3a21f2ea81e2267441fbf17a6673375a89d7301fd4e1c2ced" => :mavericks
    sha256 "d9940047cae32d7d6e3e65374f8db5cca452e322136a8b917f5627f5e5c7bd55" => :mountain_lion
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
    %w|3.0 3.1|.each do |fsharp_ver|
      %w|Microsoft.Portable.FSharp.Targets
         Microsoft.FSharp.Targets|.each do |fsharp_targ|

        tree_dir   = "lib/mono/Microsoft\ SDKs/F\#/#{fsharp_ver}/Framework/v4.5"
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
    ENV.prepend_path 'PATH', Formula["mono"].bin

    output = shell_output %{echo 'printfn "#{test_str}"; exit 0' | #{bin}/fsharpi}
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
