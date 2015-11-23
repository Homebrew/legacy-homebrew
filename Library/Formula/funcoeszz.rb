class Funcoeszz < Formula
  desc "Dozens of command-line mini-applications (Portuguese)"
  homepage "http://funcoeszz.net/"
  url "http://funcoeszz.net/download/funcoeszz-15.5.sh"
  sha256 "13e6347018b43c54f5032d4700d45255f7e26e1e8f1eacb25e324d4fbe07e15d"

  bottle :unneeded

  depends_on "bash"

  def install
    bin.install "funcoeszz-#{version}.sh" => "funcoeszz"
  end

  def caveats; <<-EOS.undent
    To use this software add to your profile:
      export ZZPATH="#{opt_bin}/funcoeszz"
      source "$ZZPATH"

    Usage of a newer Bash than the OS X default is required.
    EOS
  end

  test do
    assert_equal "15", shell_output("#{bin}/funcoeszz zzcalcula 10+5").chomp
  end
end
