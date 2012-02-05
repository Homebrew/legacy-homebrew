require 'formula'

class Boom < Formula
  url 'https://github.com/holman/boom/tarball/v0.2.3'
  homepage 'http://zachholman.com/boom/'
  md5 '5f7c833d5ac08fb7ec720727ec6c3edf'

  def install
    prefix.install %w[bin lib]
    bash_completion.install 'completion/boom.bash'
  end

  private

  def bash_completion
    etc + 'bash_completion.d'
  end
end
