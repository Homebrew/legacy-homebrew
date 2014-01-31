require 'formula'

class Kerl < Formula
  homepage 'https://github.com/spawngrid/kerl'
  url 'https://github.com/spawngrid/kerl/archive/69841dea4fadc95c4df51469104b8dbe9e51c862.zip'
  version '20140131'
  sha1 'c19285b8f4b038b6e056b43d23e968d50d44bc39'

  def install
    bin.install 'kerl'
    bash_completion.install 'bash_completion/kerl'
  end
end
