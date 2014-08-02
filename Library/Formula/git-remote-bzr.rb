require "formula"

class GitRemoteBzr < Formula
  homepage "https://github.com/felipec/git-remote-bzr"
  url "https://github.com/felipec/git-remote-bzr/archive/v0.2.tar.gz"
  sha1 "6d550d5d1072d9bd882139440344fd3e32893efc"

  def install
    libexec.install 'git-remote-bzr'
    (bin/"git-remote-bzr").write_env_script(libexec/"git-remote-bzr", {
      "PYTHONPATH" => "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages"
    })
  end
end
