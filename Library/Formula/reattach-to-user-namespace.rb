require 'formula'

class ReattachToUserNamespace < Formula
  homepage 'https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard'
  url 'https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/archive/v2.3.tar.gz'
  sha1 '830d329992b294c2673ed240ee3c7786e4e06308'

  head 'https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git'

  option 'wrap-pbcopy-and-pbpaste', 'Include wrappers for pbcopy/pbpaste that shim in this fix'
  option 'wrap-launchctl', 'Include wrapper for launchctl with this fix'

  def install
    system "make"
    bin.install "reattach-to-user-namespace"
    wrap_pbpasteboard_commands if build.include? 'wrap-pbcopy-and-pbpaste'
    wrap_launchctl if build.include? 'wrap-launchctl'
  end

  def wrap_pbpasteboard_commands
    make_executable_with_content('pbcopy', 'cat - | reattach-to-user-namespace /usr/bin/pbcopy')
    make_executable_with_content('pbpaste', 'reattach-to-user-namespace /usr/bin/pbpaste')
  end

  def wrap_launchctl
    make_executable_with_content('launchctl', 'reattach-to-user-namespace /bin/launchctl "$@"')
  end

  def make_executable_with_content(executable_name, content_lines)
    executable = bin.join(executable_name)
    content = [*content_lines].unshift("#!/bin/sh").join("\n")
    executable.write(content)
    executable.chmod(0755)
  end
end
