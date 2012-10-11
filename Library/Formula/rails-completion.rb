require 'formula'

class RailsCompletion < Formula
  homepage 'https://github.com/jweslley/rails_completion'
  url 'https://github.com/jweslley/rails_completion/tarball/v0.2.0'
  sha1 '33c06ece02aaf3ceb55921c1b8359432cf4c61d8'
  head 'https://github.com/jweslley/rails_completion.git'

  def install
    (prefix+'etc/bash_completion.d').install Dir['rails.bash']
  end
end
