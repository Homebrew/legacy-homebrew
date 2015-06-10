class Funcoeszz < Formula
  desc "Dozens of command-line mini-applications (Portuguese)"
  homepage "http://funcoeszz.net/"
  url "http://funcoeszz.net/download/funcoeszz-13.2.sh"
  sha256 "c790bafb8ba8bafa78e48179e46e670ba5cad0d13e8a631b84f7e3fe21b8d86d"

  depends_on "bash"

  depends_on "gnu-sed"

  def install
    # This program needs gnu sed to work, insted of forcing users
    # to change their paths, we just change the sed callings to gsed
    original_path = "funcoeszz-#{version}.sh"

    inreplace original_path do |s|
      s.gsub! /\bsed\b/, "gsed"
    end

    prefix.install original_path => "funcoeszz.sh"
  end

  def caveats; <<-EOS.undent
    To use this software add to your profile:
      export ZZPATH="#{opt_prefix}/funcoeszz.sh"
      source "$ZZPATH"

    Usage of a newer Bash than the OS X default is required.
    EOS
  end
end
