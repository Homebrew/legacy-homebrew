class Ism < Formula
  desc "Interactive Shell Monitor"
  homepage "https://github.com/shpoont/ism"
  url "https://github.com/shpoont/ism/archive/v0.1.tar.gz"
  sha256 "bd929defb5e99b1d1e004aa271d3980ac7044786641b69d80f2505c6b24dc389"

  head "https://github.com/shpoont/ism.git"

  bottle :unneeded

  depends_on "jq"
  depends_on "bash-preexec"

  def install
    (prefix/"etc/profile.d").install "ism.sh"
  end

  def caveats; <<-EOS.undent
    Add the following line to your bash profile (e.g. ~/.bashrc, ~/.profile, or ~/.bash_profile)

      [[ -f $(brew --prefix)/etc/profile.d/ism.sh ]] && . $(brew --prefix)/etc/profile.d/ism.sh

    EOS
  end

  test do
    # Just testing that the file is installed
    assert File.exist?("#{prefix}/etc/profile.d/ism.sh")
  end
end
