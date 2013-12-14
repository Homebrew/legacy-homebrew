require 'formula'

class RbenvCommunalGems < Formula
  homepage 'https://github.com/tpope/rbenv-communal-gems'
  url 'https://github.com/tpope/rbenv-communal-gems/archive/cbc18bc791b3a25a6b1df27e256d02b9695bb537.tar.gz'
  sha1 'e101b157bec6299c07f52adc3f2073b98cd27c79'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
