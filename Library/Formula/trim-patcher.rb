require 'formula'

class TrimPatcher < Formula
  homepage 'https://github.com/lloeki/trim_patcher'
  head 'git://github.com/lloeki/trim_patcher.git'

  def install
    bin.install 'trim_patch.py' => 'trim_patch'
  end
end
