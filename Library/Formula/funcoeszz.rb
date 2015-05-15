require 'formula'

class Funcoeszz < Formula
  homepage 'http://funcoeszz.net/'
  url 'http://funcoeszz.net/download/funcoeszz-13.2.sh'
  sha1 '33d6950dc83fd2118bc45a752c4a77be3b112573'

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
    EOS
  end
end
