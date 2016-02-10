class Eiffelstudio < Formula
  desc "A development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/15.08/eiffelstudio-15.08.tar"
  sha256 "e18a85759b0085c94b03c04e75b1cd53998b6672ac5e23d47cf7ee784c63c0b8"

  bottle do
    cellar :any
    sha256 "506e862574eb598e7ab2e955f49dd6835dffa4592008592919d7687ffb750e1f" => :el_capitan
    sha256 "312c10b1ca1b08271251e0e4c4575726bcf6df0cb1ab97aacaee1697e2c34911" => :yosemite
    sha256 "26b461996cb342538da1c30d05b55c934f850477c0dd825ff0372871079ce2a0" => :mavericks
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
