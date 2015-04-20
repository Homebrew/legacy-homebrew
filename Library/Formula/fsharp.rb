require "formula"

class Fsharp < Formula
  homepage "http://fsharp.org/"
  url "https://github.com/fsharp/fsharp.git", :tag => "3.1.1.31",
    :revision => "1f79c0455fb8b5ec816985f922413894ce19359a"

  bottle do
    sha256 "2369c57d4accee52b300d4f729941c4371e2632e3d9c52581c98176640ef9a03" => :yosemite
    sha256 "9e9f48a821e5dde7c1de040def858a6a22138441bbfd6c08cbb4e83caf6a5232" => :mavericks
    sha256 "7bc128eb9d5a4634d5d453d7935bf391f59faa94a0e07b4ee6ad287471c07591" => :mountain_lion
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
