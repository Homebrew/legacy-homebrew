require 'formula'

class RailsCompletion < Formula
  homepage 'https://github.com/jweslley/rails_completion'
  url 'https://github.com/jweslley/rails_completion/tarball/v0.2.0'
  md5 '9e3fad56de597752c4a2e10006e06ce5'
  head 'https://github.com/jweslley/rails_completion.git'

  def install
    (prefix+'etc/bash_completion.d').install Dir['rails.bash']
  end
end
