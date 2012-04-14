require 'formula'

class RailsCompletion < Formula
  homepage 'https://github.com/jweslley/rails_completion'
  url 'https://github.com/jweslley/rails_completion/zipball/v0.2.0'
  md5 '5a2ca2e938a2d72fc57b478d83be25f2'
  head 'https://github.com/jweslley/rails_completion.git'

  def install
    (prefix+'etc/bash_completion.d').install Dir['rails.bash']
  end
end
