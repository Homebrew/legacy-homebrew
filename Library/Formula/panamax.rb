require "formula"


class Panamax < Formula
  homepage "http://www.panamax.io"
  url "http://download.panamax.io/installer/panamax-0.3.1.tar.gz"
  sha1 "b86a46081eecf1c60c98c9775c785489449be479"
  def install
    system "./configure", "--prefix=#{prefix}", "--var=#{var}/panamax"
    system "make", "install"
  end

  def caveats
    "If upgrading the Panamax Installer, be sure to run 'panamax reinstall' to ensure compatibility with other Panamax components."
  end

  test do
    assert File.exist?("#{prefix}/.panamax")
    assert File.exist?("#{var}/panamax")
    assert_match "#{version}", shell_output("#{prefix}/.panamax/panamax -sv").strip
  end
end
