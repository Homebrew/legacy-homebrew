require 'formula'

class Play < Formula
  homepage 'http://www.playframework.org/'
  head 'https://github.com/playframework/playframework.git'
  url 'http://downloads.typesafe.com/play/2.0.6/play-2.0.6.zip'
  sha1 '6eab8a0d4058762be6d916a4e0062647ad16ca79'

  devel do
    url 'http://downloads.typesafe.com/play/2.2.0-M2/play-2.2.0-M2.zip'
    version '2.2.0-M2'
    sha1 '8c4d7393b8d50da4e02b59c67da2379710a305ea'
  end

  def install
    system "./framework/build", "publish-local" if build.head?

    # remove Windows .bat files
    rm Dir['*.bat']
    rm Dir["#{buildpath}/**/*.bat"] if build.head?

    # apply workaround for relative symlink, remove block when stable version reaches 2.2.x.
    # https://github.com/playframework/playframework/issues/1516
    # https://github.com/playframework/playframework/pull/777
    if build.stable?
      inreplace buildpath/"play" do |s|
        s.gsub! "$dir/", "$dir/../libexec/"
        s.gsub! "dir=`dirname $PRG`", "dir=`dirname $0` && dir=$dir/`dirname $PRG`"
      end
    end

    libexec.install Dir['*']
    bin.install_symlink libexec/'play'
  end
end
