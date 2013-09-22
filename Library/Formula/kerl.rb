require 'formula'

class Kerl < Formula
  homepage 'https://github.com/spawngrid/kerl'
  url 'https://github.com/spawngrid/kerl/archive/6cd7d5764b75efc27a53beae7c887240087e9849.zip'
  version '20130314'
  sha1 '6643b0f9490201edc7367121866c0030fddc53c8'

  def install
    bin.install 'kerl'
    bash_completion.install 'bash_completion/kerl'
  end
end
