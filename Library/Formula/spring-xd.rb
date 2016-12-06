require 'formula'

class SpringXd < Formula
  homepage 'https://github.com/SpringSource/spring-xd'
  url 'https://s3.amazonaws.com/temp.springsource.com/spring-xd-0.1.0.tar.gz'
  sha1 'ddb4f5b070fb2646687cecb8d558f012bf5bf11c'
  version '0.1.0'

  depends_on 'redis' => :recommended

  def install
    rm Dir["bin/*.bat"]
    prefix.install %w[bin lib modules]
  end
end
