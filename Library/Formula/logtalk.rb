class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3030stable.tar.gz"
  version "3.03.0"
  sha256 "fa4b674794afa1d81ca86c3eeb29dbe2b4675a92011327968c895397f0a35275"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0b9329862e0516325edb147f8400182c3795379a80b082368ca5bbae41036b3" => :el_capitan
    sha256 "d2486a554311b7ab12f2aad06911fa9acb3695447e24168222a39cb462c9c471" => :yosemite
    sha256 "9d9f2a493455fef7da589fbae8a870556005392af85e5b563eee57ff644e9280" => :mavericks
  end

  option "with-swi-prolog", "Build using SWI Prolog as backend"
  option "with-gnu-prolog", "Build using GNU Prolog as backend (Default)"

  deprecated_option "swi-prolog" => "with-swi-prolog"
  deprecated_option "gnu-prolog" => "with-gnu-prolog"

  if build.with? "swi-prolog"
    depends_on "swi-prolog"
  else
    depends_on "gnu-prolog"
  end

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
