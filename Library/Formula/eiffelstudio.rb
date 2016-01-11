class Eiffelstudio < Formula
  desc "A development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/15.08/eiffelstudio-15.08.tar"
  sha256 "e18a85759b0085c94b03c04e75b1cd53998b6672ac5e23d47cf7ee784c63c0b8"

  bottle do
    cellar :any
    sha256 "ed133a225ca5d720b23b1fd5c99e3c8ab25f5f5179f3d0e81fb06f5519bec81c" => :el_capitan
    sha256 "d95f580ea3793c39f8bde5a4b83dddbcc345010c326cfa3f6d634dae6f4e8418" => :yosemite
    sha256 "dd08958609415321088bc6c5154f15e107a1fc83ec66d23df78173c2a5c4a8d6" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def ise_platform
    if Hardware::CPU.ppc?
      "macosx-ppc"
    elsif MacOS.prefer_64_bit?
      "macosx-x86-64"
    else
      "macosx-x86"
    end
  end

  def install
    system "./compile_exes", ise_platform
    system "./make_images", ise_platform
    prefix.install Dir["Eiffel_15.08/*"]
    bin.mkpath
    env = { :ISE_EIFFEL => prefix, :ISE_PLATFORM => ise_platform }
    (bin + "ec").write_env_script(prefix+"studio/spec/#{ise_platform}/bin/ec", env)
    (bin + "ecb").write_env_script(prefix+"studio/spec/#{ise_platform}/bin/ecb", env)
    (bin + "estudio").write_env_script(prefix+"studio/spec/#{ise_platform}/bin/estudio", env)
    (bin + "finish_freezing").write_env_script(prefix+"studio/spec/#{ise_platform}/bin/finish_freezing", env)
    (bin + "compile_all").write_env_script(prefix+"tools/spec/#{ise_platform}/bin/compile_all", env)
    (bin + "iron").write_env_script(prefix+"tools/spec/#{ise_platform}/bin/iron", env)
    (bin + "syntax_updater").write_env_script(prefix+"tools/spec/#{ise_platform}/bin/syntax_updater", env)
    (bin + "vision2_demo").write_env_script(prefix+"vision2_demo/spec/#{ise_platform}/bin/vision2_demo", env)
  end

  test do
    # More extensive testing requires the full test suite
    # which is not part of this package.
    system "#{prefix}/studio/spec/#{ise_platform}/bin/ec", "-version"
  end
end
