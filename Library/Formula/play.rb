require 'formula'

class Play < Formula
  homepage 'http://www.playframework.org/'
  head 'https://github.com/playframework/playframework.git'
  url 'http://downloads.typesafe.com/play/2.1.4/play-2.1.4.zip'
  sha1 'b733bbd4a67bd99e9821366cdbae87bc3c40892c'

  devel do
    url 'http://downloads.typesafe.com/play/2.2.0-RC1/play-2.2.0-RC1.zip'
    sha1 'f4f7d577220c7f9be4020517d256f827b5a7d36d'
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
