class ReattachToUserNamespace < Formula
  desc "Reattach process (e.g., tmux) to background"
  homepage "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard"
  url "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/archive/v2.4.tar.gz"
  sha256 "645dfb77933fdb89b5935cbfc03f136c2672f8500e0a68b72acb7a1bf552a240"

  head "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e82b55ddf2919a65c5f07f6c0a37a92dab29e84301156541d2e9e76da55d8e0c" => :el_capitan
    sha256 "a4f830cb25bf7b0a77a65e4e90d24541c1e50a36450ba96a31e3ccb1ed599342" => :yosemite
    sha256 "674bb4314d34fc4fc41695d1da5fd46a98ef624d1f6b9d61b6708330109a4e24" => :mavericks
    sha256 "a43cb67207a2ce491a5806a5a11a170f74a3503ba5006b0e5dbdfb0223e1589e" => :mountain_lion
  end

  option "with-wrap-pbcopy-and-pbpaste", "Include wrappers for pbcopy/pbpaste that shim in this fix"
  option "with-wrap-launchctl", "Include wrapper for launchctl with this fix"
  deprecated_option "wrap-pbcopy-and-pbpaste" => "with-wrap-pbcopy-and-pbpaste"
  deprecated_option "wrap-launchctl" => "with-wrap-launchctl"

  def install
    system "make"
    bin.install "reattach-to-user-namespace"
    wrap_pbpasteboard_commands if build.with? "wrap-pbcopy-and-pbpaste"
    wrap_launchctl if build.with? "wrap-launchctl"
  end

  def wrap_pbpasteboard_commands
    make_executable_with_content("pbcopy", "cat - | reattach-to-user-namespace /usr/bin/pbcopy")
    make_executable_with_content("pbpaste", "reattach-to-user-namespace /usr/bin/pbpaste")
  end

  def wrap_launchctl
    make_executable_with_content("launchctl", 'reattach-to-user-namespace /bin/launchctl "$@"')
  end

  def make_executable_with_content(executable_name, content_lines)
    executable = bin.join(executable_name)
    content = [*content_lines].unshift("#!/bin/sh").join("\n")
    executable.write(content)
    executable.chmod(0755)
  end

  test do
    system bin/"reattach-to-user-namespace", "-l", "bash", "-c", "echo Hello World!"
  end
end
