require 'formula'

class Play < Formula
  homepage 'http://www.playframework.org/'
  head 'https://github.com/playframework/playframework.git'
  url 'http://downloads.typesafe.com/play/2.2.0/play-2.2.0.zip'
  sha1 '455b0c24cf94c8c59c03df0a1fd3bf7f33c2c953'

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
