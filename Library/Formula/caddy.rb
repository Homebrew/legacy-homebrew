require 'formula'
require 'language/go'

class Caddy < Formula
  homepage 'https://caddyserver.com/'
  url 'https://github.com/mholt/caddy/archive/v0.6.0.tar.gz'
  sha1 '9328fe2c59f9d5f196aa61f3fd74d585f443fc84'
  head 'https://github.com/mholt/caddy.git'

  depends_on 'go' => :build

  go_resource 'golang.org/x/net' do
    url 'https://go.googlesource.com/net.git', :revision => 'e0403b4e005737430c05a57aac078479844f919c'
  end

  go_resource 'github.com/bradfitz/http2' do
    url 'https://github.com/bradfitz/http2.git', :revision => 'f8202bc903bda493ebba4aa54922d78430c2c42f'
  end

  go_resource 'github.com/dustin/go-humanize' do
    url 'https://github.com/dustin/go-humanize.git', :revision => '00897f070f09f194c26d65afae734ba4c32404e8'
  end

  go_resource 'github.com/flynn/go-shlex' do
    url 'https://github.com/flynn/go-shlex.git', :revision => '70644ac2a65dbf1691ce00c209d185163a14edc6'
  end

  go_resource 'github.com/russross/blackfriday' do
    url 'https://github.com/russross/blackfriday.git', :revision => '4bed88b4fd00fbb66b49b0f38ed3dd0b902ab515'
  end

  go_resource 'github.com/shurcooL/sanitized_anchor_name' do
    url 'https://github.com/shurcooL/sanitized_anchor_name.git', :revision => '8e87604bec3c645a4eeaee97dfec9f25811ff20d'
  end

  def install
    mkdir_p buildpath/"src/github.com/mholt/"
    ln_s buildpath, buildpath/"src/github.com/mholt/caddy"
    ENV['GOPATH'] = buildpath
    ENV['GOOS'] = 'darwin'
    ENV['GOARCH'] = MacOS.prefer_64_bit? ? 'amd64' : '386'
    Language::Go.stage_deps resources, buildpath/"src"

    system 'go', 'build', '-o', 'caddy'
    bin.install 'caddy'
    doc.install %w(README.md LICENSE.md)
  end
end
