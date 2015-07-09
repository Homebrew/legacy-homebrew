class Funcoeszz < Formula
  desc "Dozens of command-line mini-applications (Portuguese)"
  homepage "http://funcoeszz.net/"
  url "http://funcoeszz.net/download/funcoeszz-13.2.sh"
  sha256 "c790bafb8ba8bafa78e48179e46e670ba5cad0d13e8a631b84f7e3fe21b8d86d"

  depends_on "bash"

  def install
    prefix.install "funcoeszz-#{version}.sh" => "funcoeszz.sh"
  end

  def caveats; <<-EOS.undent
    To use this software add to your profile:
      export ZZPATH="#{opt_prefix}/funcoeszz.sh"
      source "$ZZPATH"

    Usage of a newer Bash than the OS X default is required.
    EOS
  end
end
