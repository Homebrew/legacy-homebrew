require "formula"

class GitRemoteHg < Formula
  homepage "https://github.com/felipec/git-remote-hg"
  url "https://github.com/felipec/git-remote-hg/archive/v0.2.tar.gz"
  sha1 "539ed6e69099bc7630c7f45a25aae18a8fd6034b"

  def install
    libexec.install 'git-remote-hg'
    (bin/"git-remote-hg").write_env_script(libexec/"git-remote-hg", {
      "PYTHONPATH" => "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages"
    })
  end
end
