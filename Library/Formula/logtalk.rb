class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3004stable.tar.gz"
  sha256 "2f1275d43ec5c4c65161b4673ed214311272a8af131a748c37e2ffec33532dfc"
  version "3.00.4"

  bottle do
    cellar :any
    sha256 "ecba33b85ad7147dc41883f467b563814e72fc1e70b062e3805c58ec4712f3a3" => :yosemite
    sha256 "3e78e9174d6dac8e281b922a02264127165cfd0bb90c8b1e092a2c1d5eb68670" => :mavericks
    sha256 "197132d44948afbc3c0ae1c811ff8c2b81a93934f099be8a4271eb49d82ceabf" => :mountain_lion
  end

  option "with-swi-prolog", "Build using SWI Prolog as backend"
  option "with-gnu-prolog", "Build using GNU Prolog as backend"
  option "with-yap-prolog", "Build using YAP Prolog as backend (Default)"

  deprecated_option "swi-prolog" => "with-swi-prolog"
  deprecated_option "gnu-prolog" => "with-gnu-prolog"

  if build.with?("swi-prolog")
    depends_on "swi-prolog"
  elsif build.with?("gnu-prolog")
    depends_on "gnu-prolog"
  else
    depends_on "yap"
  end

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end

  def caveats; <<-EOS.undent
    You must set the LOGTALKHOME and LOGTALKUSER environment variables before
    using logtalk:

      export LOGTALKHOME=#{share}/logtalk-#{version}-stable
      export LOGTALKUSER=~/logtalk
  EOS
  end

  test do
    user_setup = testpath/"test-logtalk"
    home = "#{share}/logtalk-#{version}-stable"
    ENV["LOGTALKHOME"] = home
    ENV["LOGTALKUSER"] = user_setup
    system "#{bin}/logtalk_user_setup"
    assert File.directory? user_setup

    lgt = if build.with?("swi-prolog")
            "swilgt"
          elsif build.with?("gnu-prolog")
            "gplgt"
          else
            "yaplgt"
          end

    pipe_output("#{lgt} #{home}/examples/ack/ack.lgt 2>/dev/null", "", 0)
  end
end
