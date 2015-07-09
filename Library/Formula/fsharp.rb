require "formula"

class Fsharp < Formula
  desc "F#, a functional-first programming language"
  homepage "http://fsharp.org/"
  url "https://github.com/fsharp/fsharp.git", :tag => "3.1.2.4",
    :revision => "8d02a54a75de362d6b649dcaaacfefe6db9caf41"

  bottle do
    sha256 "48c08f9e3bfdd74898bd5cc796b3d63e66059bf056bd60822476f474135ab32d" => :yosemite
    sha256 "8db3d4e0eed760eea54b7c2b0f7efae604fae897781a07d5b78346bbf2ebb787" => :mavericks
    sha256 "4418bd6dec786b2af2f00979f2924a300abc1374e96ef2a90d06f246ed8e7976" => :mountain_lion
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
