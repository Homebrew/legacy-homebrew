require 'formula'

class HerokuToolbelt < Formula
  homepage 'https://toolbelt.heroku.com/other'
  url 'http://assets.heroku.com.s3.amazonaws.com/heroku-client/heroku-client-2.32.13.tgz'
  sha1 'b68bf43366e0a86a5d28fc152e79672fd0bc1d64'

  def shim_script target
    <<-EOS.undent
      #!/usr/bin/env sh
      exec "#{libexec}/bin/#{target}" "$@"
    EOS
  end

  def install
    libexec.install Dir["*"]
    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end
  end

  def test
    system "#{bin}/heroku", "version"
  end
end
