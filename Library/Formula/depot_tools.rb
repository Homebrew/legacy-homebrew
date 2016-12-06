require 'formula'

class DepotTools < Formula
  homepage 'http://dev.chromium.org/developers/how-tos/depottools'
  url 'https://chromium.googlesource.com/chromium/tools/depot_tools.git',
    :branch => 'master'
  version 'master'

  depends_on 'repo'

  # We're linking these tools with auto-update disabled. It's bad enough that
  # all we know is that we're at the HEAD of the master branch, since the
  # Chromium team isn't nice enough to tag releases for us.
  def install
    dst = prefix/'tools'
    dst.mkpath unless dst.directory?
    mv Dir.glob('*'), dst
    %w[gclient gcl git-cl hammer drover cpplint.py presubmit_support.py
      trychange.py git-try wtf weekly git-gs zsh-goodies].each do |tool|
      (bin/tool).write <<-EOS.undent
        #!/bin/bash
        TOOL=#{prefix}/tools/#{tool}
        export DEPOT_TOOLS_UPDATE=0
        export PATH="$PATH:#{prefix}/tools"
        exec "$TOOL" "$@"
      EOS
    end
  end

  def test
    %w[gclient presubmit_support.py trychange.py].each do |tool|
      system "#{bin}/#{tool} --version"
    end
  end
end
