require 'formula'

class Pyredis < Formula
  homepage 'https://github.com/andymccurdy/redis-py'
  url 'https://github.com/andymccurdy/redis-py/archive/2.7.5.tar.gz'
  sha1 '437f0b182dc7df05bd067233b1c251c5d44d0963'

  depends_on 'Python'
  depends_on 'redis'

  def install
    system "python", "setup.py", "install"
  end

  test do
    system "python", "-c", "import redis"
  end
end
